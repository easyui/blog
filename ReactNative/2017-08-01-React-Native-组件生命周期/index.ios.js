/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import PropTypes from 'prop-types';
import Button from './Button';
import LocationButton from './LocationButton';


import {
  AppRegistry,
  StyleSheet,
  Text,
  View
} from 'react-native';

export default class owen extends Component {
  static propTypes = {
    aaaa: owen.easyLog('propTypes'),
    animateEnd: PropTypes.func,
    age: PropTypes.number
  }

  static defaultProps = {
    aaaa: owen.easyLog('defaultProps'),
    animateEnd: function () { },
    age: 10
  }

  constructor(props) {
    owen.easyLog('constructor')
    super(props);
    this.state = {
      name: 'button改变自己state',
      showButton: true
    };

  }


  componentWillMount() {
    owen.easyLog('componentWillMount')
  }

  componentDidMount() {
    owen.easyLog('componentDidMount')
  }

  componentWillUnmount() {
    owen.easyLog('componentWillUnmount')
  }
  render() {
    owen.easyLog('render')
    return (
      <View style={styles.container}>
        {this.state.showButton ? <Button
          label={this.state.name}
          style={{ borderColor: 'red', borderWidth: 3 }}
        /> : null}
        <Text style={styles.welcome} onPress={() => { this.setState({ name: (new Date().getTime()).toString() }) }}>
          改变上面button props
        </Text>
        <Text style={styles.instructions} onPress={() => { this.setState({ showButton: !this.state.showButton }) }}>
          button show开关
        </Text>
        <LocationButton onGetCoords={(time) => { this.forceUpdate() }} />
      </View>
    );
  }


  componentWillReceiveProps(nextProps) {
    owen.easyLog('componentWillReceiveProps')
  }

  shouldComponentUpdate(nextProps, nextState) {
    owen.easyLog('shouldComponentUpdate')
    return true
  }

  componentWillUpdate(nextProps, nextState) {
    owen.easyLog('componentWillUpdate')
  }

  componentDidUpdate() {
    owen.easyLog('componentDidUpdate')
  }



  static easyLog(str) {
    console.log('-----owen: ' + str)
  }
}
const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
    borderColor: 'yellow',
    borderWidth: 3
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
    borderColor: 'green',
    borderWidth: 3
  },
});

AppRegistry.registerComponent('owen', () => owen);
