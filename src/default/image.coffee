React = require 'react'

LiteImageLoading = React.createFactory require('react-lite-misc').ImageLoading

div = React.createFactory 'div'
img = React.createFactory 'img'
span = React.createFactory 'span'

T = React.PropTypes

module.exports = React.createClass
  displayName: 'message-form-image'

  propTypes:
    collectionMode: T.bool
    onClick: T.func
    onLoaded: T.func
    attachment: T.object.isRequired
    eventBus: T.object

  getInitialState: ->
    isLoading: true
    isUploading: false

  componentDidMount: ->
    if @props.eventBus?
      unless @props.attachment.data.fileKey?.length
        @props.eventBus.addListener 'uploader/progress', @onProgress
        @props.eventBus.addListener 'uploader/complete', @onDone
        @props.eventBus.addListener 'uploader/error', @onDone

  componentWillUnoumt: ->
    if @props.eventBus?
      @props.eventBus.removeListener 'uploader/progress', @onProgress
      @props.eventBus.removeListener 'uploader/complete', @onDone
      @props.eventBus.removeListener 'uploader/error', @onDone

  onClick: ->
    @props.onClick?()

  onLoaded: ->
    @setState isLoading: false
    @props.onLoaded?()

  onProgress: ->
    if @isMounted()
      @setState isUploading: true

  onDone: ->
    if @isMounted()
      @setState isUploading: false

  renderPreview: ->
    if @props.attachment.data.thumbnailUrl?.length

      imageHeight = @props.attachment.data.imageHeight
      imageWidth = @props.attachment.data.imageWidth
      thumbnailUrl = @props.attachment.data.thumbnailUrl

      boundary = if @props.collectionMode then 200 else 240
      reg = /(\/h\/\d+)|(\/w\/\d+)/g

      if imageWidth > boundary
        previewHeight = Math.round(imageHeight / (imageWidth / boundary))
        previewWidth = boundary
      else
        previewHeight = imageHeight
        previewWidth = imageWidth

      if previewHeight > boundary
        previewWidth = Math.round(previewWidth / (previewHeight / boundary))
        previewHeight = boundary

      if reg.test thumbnailUrl
        src = thumbnailUrl
          .replace(/(\/h\/\d+)/g, "/h/#{ previewHeight }")
          .replace(/(\/w\/\d+)/g, "/w/#{ previewWidth }")
      else
        src = thumbnailUrl

      if @state.isLoading and previewHeight < 120
        style =
          height: 120
      else
        style =
          height: previewHeight

      div className: 'preview', style: style,
        LiteImageLoading
          uploading: @state.isUploading
          src: src
          onClick: @onClick
          onLoaded: @onLoaded

  render: ->
    div className: 'attachment-image',
      @renderPreview()
