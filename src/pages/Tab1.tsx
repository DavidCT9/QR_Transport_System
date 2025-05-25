import {
  IonButton,
  IonCol,
  IonContent,
  IonGrid,
  IonHeader,
  IonIcon,
  IonInput,
  IonItem,
  IonLabel,
  IonModal,
  IonPage,
  IonRow,
  IonTitle,
  IonToolbar,
} from '@ionic/react';
import './Tab1.css';
import {
  getAuth,
  signOut,
  onAuthStateChanged,
  User
} from "firebase/auth";
import {
  getDatabase,
  ref,
  onValue,
  remove,
  set,
} from "firebase/database";
import { useEffect, useState } from 'react';
import {
  key,
  trash,
  addCircleOutline,
  checkmark,
  close,
  logOut
} from 'ionicons/icons';
import { useHistory } from 'react-router-dom'; // ✅ Needed to navigate to /login

const Tab1: React.FC = () => {
  const [keysList, setKeysList] = useState<any>({});
  const [usersList, setUsersList] = useState<any>({});
  const [showModal, setShowModal] = useState(false);
  const [newKey, setNewKey] = useState({ id: '', status: '', user: '' });

  const history = useHistory(); // ✅ useHistory to redirect
  const auth = getAuth();
  const [currentUser, setCurrentUser] = useState<User | null>(auth.currentUser);

  // ✅ Logout Handler
  const handleLogout = async () => {
    try {
      await signOut(auth);
      setKeysList({});
      setUsersList({});
      history.push("/login"); // ⬅️ redirect after logout
    } catch (error) {
      console.error("Logout failed:", error);
    }
  };

  // ✅ Listen for Auth State
  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, user => {
      setCurrentUser(user);
      if (!user) {
        history.push("/login"); // ⬅️ redirect if not authenticated
      }
    });
    return unsubscribe;
  }, [auth, history]);

  useEffect(() => {
    if (!currentUser) return; // ⬅️ don’t fetch if not authenticated

    const db = getDatabase();
    const keysRef = ref(db, "Keys");
    onValue(keysRef, (snapshot) => {
      const data = snapshot.val() || {};
      setKeysList(data);
    });

    const usersRef = ref(db, "users");
    onValue(usersRef, snapshot => {
      const data = snapshot.val() || {};
      setUsersList(data);
    });
  }, [currentUser]); // Only fetch if logged in

  const getUserName = (userHash: string): string => {
    return usersList[userHash]?.names || 'Unknown';
  };

  const handleDelete = (keyId: string) => {
    const db = getDatabase();
    const usersRef = ref(db, `/users/${keyId}`);
    remove(usersRef)
      .then(() => console.log(`Deleted user: ${keyId}`))
      .catch((err) => console.error("Delete failed", err));
  };

  const handleAddKey = () => {
    const { id: baseId, status, user } = newKey;
    if (!baseId || !status || !user) return;

    const db = getDatabase();
    const writes: Promise<void>[] = [];

    for (let i = 0; i < 5; i++) {
      const suffix = String.fromCharCode(65 + i);
      const newId = `${baseId}${suffix}`;
      const keyRef = ref(db, `Keys/${newId}`);
      writes.push(
        set(keyRef, {
          status,
          user,
        })
      );
    }

    Promise.all(writes)
      .then(() => {
        console.log(`✅ Added 5 keys: ${baseId}A ... ${baseId}E`);
        setShowModal(false);
        setNewKey({ id: '', status: '', user: '' });
      })
      .catch((err) => console.error("Bulk add failed", err));
  };

  const keyColor = (keyData: { status: string }): string => {
    if (keyData.status === "available") {
      return "green";
    } else if (keyData.status === "used") {
      return "red";
    } else {
      return "yellow";
    }
  };

  return (
    <IonPage>
      <IonHeader>
        <IonToolbar>
          <IonTitle>Keys List</IonTitle>
          <IonButton slot="end" onClick={handleLogout} color="danger">
            <IonIcon icon={logOut} /> Logout
          </IonButton>
        </IonToolbar>
      </IonHeader>
      <IonContent fullscreen>
        <IonGrid>
          <IonRow className="ion-text-center">
            <IonCol><strong>QR CODE</strong></IonCol>
            <IonCol><strong>STATUS</strong></IonCol>
            <IonCol><strong>USER</strong></IonCol>
          </IonRow>

          {Object.entries(keysList).map(([keyId, keyData]) => (
            <IonRow key={keyId} className="ion-text-center">
              <IonCol>{keyId}</IonCol>
              <IonCol>
                <span style={{ color: keyColor(keyData), fontWeight: "bold" }}>
                  {keyData.status}
                </span>
              </IonCol>
              <IonCol>{getUserName(keyData.user)}</IonCol>
            </IonRow>
          ))}

          <IonRow className="ion-padding-top">
            <IonCol>
              <IonButton
                color="dark"
                expand="block"
                shape="round"
                onClick={() => setShowModal(true)}
              >
                <IonIcon color='success' icon={addCircleOutline} />
                &nbsp; Add QR Code
              </IonButton>
            </IonCol>
          </IonRow>
        </IonGrid>

        {/* Modal */}
        <IonModal isOpen={showModal} onDidDismiss={() => setShowModal(false)}>
          <IonHeader>
            <IonToolbar>
              <IonTitle>  Add New QR Key  </IonTitle>
            </IonToolbar>
          </IonHeader>
          <IonContent className="ion-padding">
            <IonItem>
              <IonLabel position="stacked">New QR Code</IonLabel>
              <IonInput value={newKey.id} onIonChange={(e) => setNewKey({ ...newKey, id: e.detail.value! })} />
            </IonItem>
            <IonItem>
              <IonLabel position="stacked">Status</IonLabel>
              <IonInput value={newKey.status} onIonChange={(e) => setNewKey({ ...newKey, status: e.detail.value! })} />
            </IonItem>
            <IonItem>
              <IonLabel position="stacked">User</IonLabel>
              <IonInput value={newKey.user} onIonChange={(e) => setNewKey({ ...newKey, user: e.detail.value! })} />
            </IonItem>
            <IonButton expand="block" shape="round" onClick={handleAddKey} className="ion-margin-top" color="success">
              <IonIcon icon={checkmark} /> Add Key
            </IonButton>
            <IonButton expand="block" shape="round" onClick={() => setShowModal(false)} className="ion-margin-top" color="medium">
              <IonIcon icon={close} className="red" /> Cancel
            </IonButton>
          </IonContent>
        </IonModal>

        {/* Users List */}
        <IonHeader>
          <IonToolbar>
            <IonTitle>Users List</IonTitle>
          </IonToolbar>
        </IonHeader>
        <IonGrid>
          <IonRow className="ion-text-center">
            <IonCol><strong>NAME</strong></IonCol>
            <IonCol><strong>LASTNAME</strong></IonCol>
            <IonCol><strong>MAJOR</strong></IonCol>
            <IonCol><strong>ACTION</strong></IonCol>
          </IonRow>

          {Object.entries(usersList).map(([userId, userData]) => (
            <IonRow key={userId} className="ion-text-center">
              <IonCol>{userData.names}</IonCol>
              <IonCol>{userData.lastname}</IonCol>
              <IonCol>{userData.major}</IonCol>
              <IonCol>
                <IonButton color="light" expand="block" shape="round" onClick={() => handleDelete(userId)}>
                  <IonIcon icon={trash} /> &nbsp; Delete
                </IonButton>
              </IonCol>
            </IonRow>
          ))}
        </IonGrid>
      </IonContent>
    </IonPage>
  );
};

export default Tab1;
