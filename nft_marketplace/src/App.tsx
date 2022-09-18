import { useContext, useEffect } from 'react';
import './App.css';
import { userContext } from './contexts/UserContextProvider';


function App() {
  const {userInfo} = useContext(userContext)

  return (
    <div className="App">
      <h1>NFT MarketPlace</h1>
    </div>
  );
}

export default App;
