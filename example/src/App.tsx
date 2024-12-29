import { StyleSheet, View } from 'react-native';
import { MaskableText } from 'react-native-maskable-text';

export default function App() {
  return (
    <View style={styles.container}>
      <MaskableText
        style={styles.text}>
        Normal
      </MaskableText>
      <MaskableText
        style={styles.text}
        colors={['#ffffff', '#000000']}>
        Gradient
      </MaskableText>
      <MaskableText
        style={styles.text}
        image={require('./african_print.jpg')}>
        Image
      </MaskableText>
      <MaskableText
        style={styles.textSmall}>
      Inline <MaskableText
        style={styles.textSmall}
        colors={['#ffffff', '#000000']}>Gradient</MaskableText>
      </MaskableText>
      <MaskableText
        style={styles.textSmall}>
      Inline <MaskableText
        style={[
          styles.textSmall,
          styles.textWithRoundedBackground
        ]}>Padded Background</MaskableText>
      </MaskableText>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'space-between',
    padding: 20,
  },
  text: {
    flex: 0,
    fontSize: 50,
    fontWeight: '700',
  },
  textSmall: {
    flex: 0,
    fontSize: 30,
    fontWeight: '700',
  },
  textWithRoundedBackground: {
    padding: 10,
    borderRadius: 10,
    backgroundColor: '#ff8fab',
    color: '#ffffff',
    textAlign: 'center',
  }
});
