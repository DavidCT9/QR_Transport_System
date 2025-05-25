import {
  IonButton,
  IonContent,
  IonHeader,
  IonInput,
  IonPage,
  IonTitle,
  IonToolbar,
  IonCard,
  IonCardContent,
  IonText,
  IonToast,
  IonLoading,
} from '@ionic/react';
import './LoginPage.css';
import { useState } from 'react';
import { getDatabase, ref, onValue, child } from 'firebase/database';
import { getAuth, signInWithEmailAndPassword, onAuthStateChanged, User } from "firebase/auth";
import { useHistory } from 'react-router';


const LoginPage: React.FC = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showToast, setShowToast] = useState(false);
  const [toastMessage, setToastMessage] = useState('');
  const [loading, setLoading] = useState(false);

  const history = useHistory();

const handleLogin = async () => {
  if (!email || !password) {
    setToastMessage('Please enter both email and password.');
    setShowToast(true);
    return;
  }

  setLoading(true);

  const auth = getAuth();

  try {
    // ✅ Wait for login result
    const userCredential = await signInWithEmailAndPassword(auth, email, password);
    
    console.log('✅ User logged in:', userCredential.user);

    // ✅ Redirect after successful login
    history.push('/tab1');
  } catch (error: any) {
    console.error('❌ Login failed:', error.message);
    setToastMessage('Invalid email or password.');
    setShowToast(true);
  } finally {
    setLoading(false);
  }
};

  return (
    <IonPage>
      <IonHeader>
        <IonToolbar color="light">
          <IonTitle>QR Transport Admin</IonTitle>
        </IonToolbar>
      </IonHeader>
      <IonContent fullscreen className="ion-padding login-content ">
        <IonCard className="login-card">
          <IonCardContent >
            <IonTitle className="login-title">Welcome</IonTitle>
            <IonText color="dark ion-text-center">
              <p>Please log in to monitor QR codes</p>
            </IonText>
            <IonInput
              fill="outline"
              placeholder="Email"
              type="email"
              className="input-dark"
              value={email}
              onIonChange={(e) => setEmail(e.detail.value!)}
            />
            <IonInput
              fill="outline"
              placeholder="Password"
              type="password"
              className="input-dark"
              value={password}
              onIonChange={(e) => setPassword(e.detail.value!)}
            />
            <IonButton expand="block" onClick={handleLogin} className="login-button">
              Log In
            </IonButton>
          </IonCardContent>
        </IonCard>
        <IonToast
          isOpen={showToast}
          onDidDismiss={() => setShowToast(false)}
          message={toastMessage}
          duration={2000}
          color="danger"
        />
        <IonLoading isOpen={loading} message={'Authenticating...'} />
      </IonContent>
    </IonPage>
  );
};

export default LoginPage;
