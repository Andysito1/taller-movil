importScripts('https://www.gstatic.com/firebasejs/9.22.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.22.0/firebase-messaging-compat.js');

const firebaseConfig = {
  apiKey: 'AIzaSyC3qGygN-FgG9IGXb1UDFBkO_2bDVvQgeg',
  authDomain: 'taller-movil-491200.firebaseapp.com',
  projectId: 'taller-movil-491200',
  storageBucket: 'taller-movil-491200.firebasestorage.app',
  messagingSenderId: '12152361848',
  appId: '1:12152361848:web:772c23584c1490e4516e8d'
};

firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

// Manejador de mensajes en segundo plano para la Web
messaging.onBackgroundMessage((payload) => {
  console.log('Mensaje en segundo plano recibido: ', payload);

  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/icons/Icon-192.png'
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});