import React, { Component } from "react";
import Button from "./ButtonInLocal";
import { StyleSheet } from "react-native";

const style = { backgroundColor: "#DDDDDD" };

class LocationButton extends Component {
  static propTypes = {
    aaaa: LocationButton.easyLog('propTypes'),
  }

  static defaultProps = {
    aaaa: LocationButton.easyLog('defaultProps'),
  }

  constructor(props) {
    LocationButton.easyLog('constructor')
    super(props);
    this.state = {
      title: 'title',
    };
  }

  componentWillMount() {
    LocationButton.easyLog('componentWillMount')
  }

  componentDidMount() {
    LocationButton.easyLog('componentDidMount')
  }

  componentWillUnmount() {
    LocationButton.easyLog('componentWillUnmount')
  }

  render() {
    LocationButton.easyLog('render')
    return (
      <Button
        label="this.forceUpdate()"
        style={style}
        onPress={this._onPress.bind(this)}
      />
    );
  }

  componentWillReceiveProps(nextProps) {
    LocationButton.easyLog('componentWillReceiveProps')
  }

  shouldComponentUpdate(nextProps, nextState) {
    LocationButton.easyLog('shouldComponentUpdate')
    return true
  }

  componentWillUpdate(nextProps, nextState) {
    LocationButton.easyLog('componentWillUpdate')
  }

  componentDidUpdate() {
    LocationButton.easyLog('componentDidUpdate')
  }

  static easyLog(str) {
    console.log('-----LocationButton: ' + str)
  }

  _onPress() {
    this.props.onGetCoords((new Date().getTime()).toString())
  }
}

const styles = StyleSheet.create({
  locationButton: { width: 200, padding: 25, borderRadius: 5 }
});

export default LocationButton;
