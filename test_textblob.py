from textblob import TextBlob

b = TextBlob("bonjour")
print(b.detect_language())