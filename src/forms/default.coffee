React = require 'react'

div = React.createFactory 'div'

T = React.PropTypes

module.exports = React.createClass
  displayName: 'message-form-default'

  propTypes:
    attachment: T.object.isRequired

  render: ->
    div className: 'message-forms-default',
      @props.attachment