class ShortUrlCreator extends React.Component {
  constructor(props) {
    super(props);
    this.state = { value: '' };

    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleChange(event) {
    this.setState({ value: event.target.value });
  }
  
  handleSubmit(event) {
    event.preventDefault();

    this.props.createMethod(this.state.value);
  }
  
  render() {
    if(this.props.doneMessage == '') {
      return (
        <form onSubmit={this.handleSubmit}>
          <label>
            Create Short URL:
            <input id="create-url-input" type="text" value={this.state.value} onChange={this.handleChange} />
          </label>
          <input type="submit" value="Submit" />
        </form>
      );
    } else {
      return (
        <div id="create-done-message-div">
          {this.props.doneMessage}
        </div>
      );
    }
  }
}
