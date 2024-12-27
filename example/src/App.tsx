import { StyleSheet, View } from 'react-native';
import { MaskableText } from 'react-native-maskable-text';
import { Text } from 'react-native';

export default function App() {
  return (
    <View style={styles.container}>
      <Text>
        React Native Text
      </Text>
      <MaskableText
        style={[styles.text, {color: '#301fff'}]}
        onPress={() => console.log("test")}>
        Normal
      </MaskableText>
      <MaskableText
        style={[styles.text, {color: '#c00c01'}]}
        colors={['#c00c01', '#315000']}>
        Gradient
      </MaskableText>
      <MaskableText
        style={[styles.text, {color: '#effef1'}]}>
        Image (TBA)
      </MaskableText>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 20
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
  text: {
    fontSize: 60,
    fontWeight: '700',
  }
});
