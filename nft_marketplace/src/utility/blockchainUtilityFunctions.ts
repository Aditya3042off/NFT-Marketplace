import detectEthereumProvider from '@metamask/detect-provider'
const Web3  = require('web3/dist/web3.min.js');

export async function fetchProvider(){
    const provider:any = await detectEthereumProvider()
    return provider
}

async function fetchWeb3(provider:any) {
    const web3:any = new Web3(provider)
    return web3
}

export async function fetchUserInfo() {
    let userInfo = {
        address:'',
        chainId:0,
        error:''
    }

    const provider:any = await fetchProvider()
    //no provider found
    if(!provider) return userInfo

    const accounts = await provider.request({method:'eth_accounts'})
    const chainId = await provider.request({method:'eth_chainId'})

    return {
        ...userInfo,
        address: accounts[0],
        chainId: parseInt(chainId,16)
    }
}

export async function loginToMetamask() {
    let userInfo = {
        address:'',
        chainId:0,
        error:''
    }
    const provider:any = fetchProvider()

    //no provider found
    if(!provider) return {
        ...userInfo,
        error:'Please Intsall Metamask'
    }

    try {
        await provider.request({method:'eth_requestAccounts'})
    } 
    catch (error:any) {
        if(error.code === 4001) {
            return {
                ...userInfo,
                error:'Please connect to Metamask'
            }
        }
    }
}