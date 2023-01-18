Acno is a mobile Android app that uses machine learning technology to detect acne. The app allows users to take a photo of their skin and then analyzes the image to identify any acne present. The app can also track the progression of the user's acne over time and provide suggestions for treatment. This technology can help users better understand their skin condition and make informed decisions about their skincare routine.

Acno, with its use of machine learning technology to detect acne, is an innovation in the skin care industry in several ways:

- Convenience: The app allows users to quickly and easily take a photo of their skin and get a diagnosis, without having to visit a dermatologist.

- Personalization: The app can track the progression of the user's acne over time and provide personalized suggestions for treatment.

- Increased understanding: The app helps users better understand their skin condition by providing an accurate diagnosis and explanations of their condition, which can lead to more informed decisions about their skincare routine.

- Cost-effective: By providing an easy to use and accurate diagnosis, the app can help people avoid unnecessary trips to the dermatologist, which can be costly.

- Increased accessibility: The app can be used by people who live in remote or underserved areas, who may not have easy access to a dermatologist.

By incorporating machine learning technology to detect acne, the Acno app represents a significant step forward in the skin care industry, providing users with convenient, personalized, and cost-effective solutions for managing their skin condition.

Acno specifically uses a Convolutional Neural Network (CNN) as the machine learning algorithm to detect acne. The app was trained on a dataset of 625 images, which were used to teach the algorithm how to recognize and classify different types of acne.
With the limited dataset of 625 images, the app achieved an accuracy of 47%. This may not be a high accuracy, but it is a good starting point for a model that is trained on a limited dataset.

One of the reasons for the lower accuracy could be the small dataset size, which may not have enough variation to train the model effectively. Additionally, the quality and diversity of the images in the dataset could also play a role in the model's accuracy.
It is important to note that this is just the starting point, and with more data, the model can be retrained to improve its accuracy.

Using a small dataset is a common challenge in developing machine learning models. To overcome this challenge, data augmentation techniques such as rotation, flipping, and zooming were applied to the images in the dataset to increase the diversity of the training data. Furthermore, transfer learning was applied to fine-tune a pre-trained CNN model on the Acno's dataset. These techniques helped to improve the model's performance and accuracy.

Acno uses Firebase as the database for storing and managing user data, including images of their skin and information related to their acne diagnosis. Firebase is a popular choice for mobile app development because it provides a set of cloud-based tools for storing and synchronizing data in real-time, which can be easily integrated with Android apps.

In addition to using Firebase for the database, Acno also uses it for online login data encryption. Firebase provides built-in support for user authentication and data encryption, which helps ensure that user data is secure and protected from unauthorized access.

The server-side logic of Acno is implemented in Flask, a popular Python web framework. Flask is lightweight and easy to use, which makes it well-suited for building web APIs that can be easily integrated with mobile apps.

Finally, the front-end of Acno is developed in Dart and Android Studio. Dart is an open-source programming language that is similar to Java and JavaScript, and it is used to develop the mobile app. Android Studio is the official Integrated Development Environment (IDE) for Android app development, it provides a complete set of tools for building and deploying mobile apps, and it natively supports both Java and Kotlin, and now Dart.

In summary, Acno uses Firebase for the database and data encryption, Flask for the server-side logic, and Dart with Android Studio for the front-end development. These technologies work together to provide an efficient and secure platform for managing user data and providing an accurate acne diagnosis.
