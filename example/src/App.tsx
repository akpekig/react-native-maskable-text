import { StyleSheet, View } from 'react-native';
import { MaskableText } from 'react-native-maskable-text';

export default function App() {
  return (
    <View style={styles.container}>
      <MaskableText
        style={[styles.text]}>
        Normal
      </MaskableText>
      <MaskableText
        style={[styles.text]}
        colors={['#ffffff', '#000000']}>
        Gradient
      </MaskableText>
      <MaskableText
        style={[styles.text]}
        image={require('./african_print.jpg')}>
        Image
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
