/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  Platform,
  StyleSheet,
  Text,
  View,
  ScrollView,
  Dimensions
} from 'react-native';
const { height, width } = Dimensions.get('window');

const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\n' +
    'Cmd+D or shake for dev menu',
  android: 'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});

export default class App extends Component<{}> {

  _renderItems = () => {
    let arr = []
    for (let i = 0; i < 100; i++) {
      // arr.push(<View style={{ height: 80 ,backgroundColor: i%2 ? 'red' : 'yellow'}} key={i}><Text>{i}</Text></View>)
      arr.push(<View style={{ width: width ,backgroundColor: i%2 ? 'red' : 'yellow'}} key={i}><Text>{i}</Text></View>)
      
    }
    return arr
  }


onScroll = (e) => {
  this.print('onScroll')
}

render() {
  return (
    <ScrollView

      ref={'scroll'}

      onScroll={this.onScroll}

      onTouchStart={() => this.print('onTouchStart')}

      onTouchMove={() => this.print('onTouchMove')}

      onTouchEnd={() => this.print('onTouchEnd')}

      onScrollBeginDrag={() => this.print('onScrollBeginDrag')}

      onScrollEndDrag={() => this.print('onScrollEndDrag')}

      onMomentumScrollBegin={() => this.print('onMomentumScrollBegin')}

      onMomentumScrollEnd={() => this.print('onMomentumScrollEnd')}

      onStartShouldSetResponder={() => this.print('onStartShouldSetResponder')}

      onStartShouldSetResponderCapture={() => this.print('onStartShouldSetResponderCapture')}

      onMoveShouldSetResponder={() => this.print('onMoveShouldSetResponder')}
      
      onMoveShouldSetResponderCapture={() => this.print('onMoveShouldSetResponderCapture')}

      onScrollShouldSetResponder={() => this.print('onScrollShouldSetResponder')}

      onResponderGrant={() => this.print('onResponderGrant')}

      onResponderMove={() => this.print('onResponderMove')}
      
      onResponderTerminationRequest={() => this.print('onResponderTerminationRequest')}

      onResponderTerminate={() => this.print('onResponderTerminate')}

      onResponderRelease={() => this.print('onResponderRelease')}

      onResponderReject={() => this.print('onResponderReject')}

      scrollEventThrottle={16}

      horizontal={true}
      pagingEnabled={true}
    >
      {
        this._renderItems()
      }
    </ScrollView>
  )
}

print(log){
  console.log('cactus------ '  + log)
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
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
