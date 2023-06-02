class ShortUrlItem extends React.Component {
  constructor(props) {
    super(props);

    this.handleDisableClick = this.handleDisableClick.bind(this);
  }
  
  truncateUrl(url) {
    if(url.length < 30) { return url; }
    return url.substr(0, 25) + ' ... ' + url.substr(url.length - 25, url.length);
  }  

  renderDisableButton() {
    if(!this.props.shortUrl.disabled) {
      return (
        <input type="button" value="Disable" onClick={this.handleDisableClick} />
      );
    } else {
      return (
        <span>Disabled</span>
      );
    }
  }

  handleDisableClick(event) {
    this.props.disableMethod(this.props.shortUrl.public_identifier);
  }
  
  render() {
    var shortUrl = this.props.shortUrl;
    
    return (
      <tr>
        <td>
          <a href={shortUrl.original_url}>{this.truncateUrl(shortUrl.original_url)}</a>
        </td>
        <td>
          <a href={shortUrl.small_url}>{shortUrl.small_url}</a>
        </td>
        <td>{shortUrl.visit_count}</td>
        <td>{this.renderDisableButton()}</td>
      </tr>
    );
  }
}
