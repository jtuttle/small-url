class SharesPage extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      shortUrls: [],
      createDoneMessage: ''
    };

    this.createShortUrl = this.createShortUrl.bind(this);
    this.disableShortUrl = this.disableShortUrl.bind(this);
  }
  
  componentDidMount() {
    var intervalId =
      setInterval(() => {
        this.loadShortUrls();
      }, 5000);

    this.setState({ intervalId: intervalId });
    
    this.loadShortUrls();
  }
  
  componentWillUnmount() {
    clearInterval(this.state.intervalId);
  }

  handleLogout() {
    promise.del("/logout").
      then(function(error, response, ehr) {
        if(!error) {
          window.location.replace('/login');
        }
      });
  }

  loadShortUrls() {
    promise.get(this.props.url_service_host + "/urls.json",
                { owner_identifier: this.props.user_identifier }).
      then((error, response, ehr) => {
        var shortUrls = JSON.parse(response).urls;
        this.setState({ shortUrls: shortUrls });
      });
  }

  createShortUrl(long_url) {
    promise.post(this.props.url_service_host + "/url/create",
                 { url: long_url,
                   owner_identifier: this.props.user_identifier }).
      then((error, response, ehr) => {
        if(error) {
          this.setState({ createDoneMessage: JSON.parse(response).error });
        } else {
          var message = 'Created short URL: ' + JSON.parse(response).url;
          this.setState({ value: '', createDoneMessage: message });
        }
        
        setTimeout(() => {
          this.setState({ createDoneMessage: '' });
        }, 2000);
        
        this.loadShortUrls();
      });
  }

  disableShortUrl(url_identifier) {
    promise.del(this.props.url_service_host + "/url/" + url_identifier).
      then((error, response, ehr) => {
        if(!error) {
          this.loadShortUrls();
        }
      });
  }
  
  render() {
    return (
      <div>
        <span id="welcome-span">Welcome {this.props.username}!</span>
        <span id="logout-button">
          <input type="button" value="Logout" onClick={this.handleLogout} />
        </span>
        <div id="url-creator">
          <ShortUrlCreator createMethod={this.createShortUrl}
                           doneMessage={this.state.createDoneMessage}
                           />
        </div>
        <ShortUrlsList shortUrls={this.state.shortUrls}
                       disableMethod={this.disableShortUrl} />
      </div>
    );
  }
}
