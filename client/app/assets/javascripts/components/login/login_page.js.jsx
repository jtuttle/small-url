/* TODO: DRY this up w/ the user creation page! It's very similar. */

class LoginPage extends React.Component {
  constructor(props) {
    super(props);
    this.state = { username: '', password: '', errorMessage: '' };
    
    this.handleUsernameChange = this.handleUsernameChange.bind(this);
    this.handlePasswordChange = this.handlePasswordChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);   
  }

  handleUsernameChange(event) {
    this.setState({ username: event.target.value });
  }
  
  handlePasswordChange(event) {
    this.setState({ password: event.target.value });
  }

  handleSubmit(event) {
    promise.post("/login",
                 { username: this.state.username,
                   password: this.state.password }).
      then((error, response, ehr) => {
        if(error) {
          this.setState({ errorMessage: JSON.parse(response).error });
        } else {
          window.location.replace('/shares');
        }
      });
  }
  
  render() {
    return (
      <div id="login-form">
        <form>
          <h2>Login</h2>
          <label>
            <div>Username:</div>
            <input className="form-input" type="text" value={this.state.username} onChange={this.handleUsernameChange} />
          </label>
          <br/>
          <label>
            <div>Password:</div>
            <input className="form-input" type="password" value={this.state.password} onChange={this.handlePasswordChange} />
          </label>
          <br/>
          <input type="button" value="Submit" onClick={this.handleSubmit} />
        </form>

        <div id="error-div">
          {this.state.errorMessage}
        </div>

        <div id="sign-up-div">
          or <a href="/signup">Sign Up</a>
        </div>
      </div>
    );
  }
}
