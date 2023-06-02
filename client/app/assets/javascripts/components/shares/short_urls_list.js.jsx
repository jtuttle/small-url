class ShortUrlsList extends React.Component {
  render() {
    var shortUrls = [];
    
    if(this.props.shortUrls != null) {
      shortUrls = this.props.shortUrls;
    }

    return (
      <table>
        <thead>
          <tr>
            <th>Original URL</th>
            <th>Short URL</th>
            <th>Visit Count</th>
          </tr>
        </thead>
        <tbody>
          {shortUrls.map((shortUrl, i) => {
            return <ShortUrlItem key={i}
                                 shortUrl={shortUrl}
                                 disableMethod={this.props.disableMethod} />
          })}
        </tbody>
      </table>
    );
  }
}
