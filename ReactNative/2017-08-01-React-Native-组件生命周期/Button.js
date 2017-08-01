import React, { Component } from "react";

import { Text, View, TouchableHighlight, StyleSheet } from "react-native";


class Button extends Component {
  static propTypes = {
    aaaa: Button.easyLog('propTypes'),
  }

  static defaultProps = {
    aaaa: Button.easyLog('defaultProps'),
  }

  constructor(props) {
    Button.easyLog('constructor')
    super(props);
    this.state = {
      title: 'title',
    };
  }


  componentWillMount() {
    Button.easyLog('componentWillMount')
  }

  componentDidMount(){
        Button.easyLog('componentDidMount')
  }

  componentWillUnmount() {
    Button.easyLog('componentWillUnmount')
  }



  render() {
    Button.easyLog('render')
    return (
      <TouchableHighlight onPress={this.props.onPress || (() => {this.setState({title:(new Date().getTime()).toString()})})}>
        <View style={[styles.button, this.props.style]}>
          <Text>
            {this.props.label}--{this.state.title}
          </Text>
        </View>
      </TouchableHighlight>
    );
  }

  componentWillReceiveProps(nextProps) {
    Button.easyLog('componentWillReceiveProps')
  }

  shouldComponentUpdate(nextProps, nextState) {
    Button.easyLog('shouldComponentUpdate')
    return true
  }

  componentWillUpdate(nextProps, nextState) {
    Button.easyLog('componentWillUpdate')
  }

  componentDidUpdate() {
    Button.easyLog('componentDidUpdate')
  }

  static easyLog(str) {
    console.log('-----Button: ' + str)
  }
}



const styles = StyleSheet.create({
  button: { backgroundColor: "#FFDDFF", padding: 25, borderRadius: 5 }
});

export default Button;
