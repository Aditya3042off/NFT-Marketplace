import {createContext,useEffect,useState} from 'react'
import { fetchUserInfo } from '../utility/blockchainUtilityFunctions';

interface userInfoInterface {
    address:string,
    chainId:number,
    error:string
}
interface userContextInterface {
    userInfo:userInfoInterface,
    setUserInfo: React.Dispatch<React.SetStateAction<userInfoInterface>>
}

export const userContext = createContext<userContextInterface | any>(null);

const UserContextProvider: React.FC<{children: JSX.Element}> = ({children}) => {
  const [userInfo,setUserInfo] = useState<userInfoInterface>({address:'',chainId:0,error:''});

  useEffect(() => {
    const loadUserInfo = async() => {
        let loggedInUserInfo = await fetchUserInfo()
        setUserInfo(prev => loggedInUserInfo)
    }
    loadUserInfo()
  },[])

  useEffect(() => {
    if(userInfo.address !== '' && userInfo.chainId !== 0) {
        const handleAccountsChanged = (accounts:any[]) => {
            // for handling the case when user disconnects then accounts array will be empty
            if(accounts.length === 0) accounts.push('');
            setUserInfo(prevState => ({
            ...prevState,
            address:accounts[0]
            }))
       };

        const handleChainChanged = (chainId:any) => {
            setUserInfo(prevState => ({
            ...prevState,
            chainId: parseInt(chainId,16)
            }))
        };
      
        window.ethereum.on('accountsChanged',handleAccountsChanged)

        window.ethereum.on('chainChanged',handleChainChanged)
      
        return () => {
            window.ethereum.removeListener('accountsChanged',handleAccountsChanged)
            window.ethereum.removeListener('chainChanged',handleChainChanged)
        }
    }
  })

  return (
    <userContext.Provider value={{userInfo,setUserInfo}}>
        {children}
    </userContext.Provider> 
  )
}

export default UserContextProvider

