import React, { Component } from "react";

import { Text, View, TouchableHighlight, StyleSheet } from "react-native";


class ButtonInLocal extends Component {
  static propTypes = {
    aaaa: ButtonInLocal.easyLog('propTypes'),
  }

  static defaultProps = {
    aaaa: ButtonInLocal.easyLog('defaultProps'),
  }

  constructor(props) {
    ButtonInLocal.easyLog('constructor')
    super(props);
    this.state = {
      title: 'title',
    };
  }


  componentWillMount() {
    ButtonInLocal.easyLog('componentWillMount')
  }

  componentDidMount() {
    ButtonInLocal.easyLog('componentDidMount')
  }

  componentWillUnmount() {
    ButtonInLocal.easyLog('componentWillUnmount')
  }



  render() {
    ButtonInLocal.easyLog('render')
    return (
      <TouchableHighlight onPress={this.props.onPress || (() => { this.setState({ title: (new Date().getTime()).toString() }) })}>
        <View style={[styles.button, this.props.style]}>
          <Text>
            {this.props.label}--{this.state.title}
          </Text>
        </View>
      </TouchableHighlight>
    );
  }

  componentWillReceiveProps(nextProps) {
    ButtonInLocal.easyLog('componentWillReceiveProps')
  }

  shouldComponentUpdate(nextProps, nextState) {
    ButtonInLocal.easyLog('shouldComponentUpdate')
    return true
  }

  componentWillUpdate(nextProps, nextState) {
    ButtonInLocal.easyLog('componentWillUpdate')
  }

  componentDidUpdate() {
    ButtonInLocal.easyLog('componentDidUpdate')
  }

  static easyLog(str) {
    console.log('-----ButtonInLocal: ' + str)
  }
}



const styles = StyleSheet.create({
  button: { backgroundColor: "#FFDDFF", padding: 25, borderRadius: 5 }
});

export default ButtonInLocal;
