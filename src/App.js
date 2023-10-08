import React, { useState, useEffect } from 'react';
import Web3 from 'web3';
import STANDARD_ABI from './ABI.json';

function App() {
    const [web3, setWeb3] = useState(null);
    const [contract, setContract] = useState(null);
    const [contractAddress, setContractAddress] = useState('');
    const [abi, setABI] = useState(STANDARD_ABI);
    const [customABI, setCustomABI] = useState('');

    useEffect(() => {
        const initWeb3 = async () => {
            if (window.ethereum) {
                const web3Instance = new Web3(window.ethereum);
                setWeb3(web3Instance);
            } else if (window.web3) {
                const web3Instance = new Web3(window.web3.currentProvider);
                setWeb3(web3Instance);
            } else {
                console.log("No Ethereum browser extension detected.");
            }
        }

        initWeb3();
    }, []);

    useEffect(() => {
        if (web3 && contractAddress && abi) {
            const contractInstance = new web3.eth.Contract(abi, contractAddress);
            setContract(contractInstance);
        }
    }, [web3, contractAddress, abi]);

    const handleButtonClick = async () => {
        if (contract) {
            // Aquí llamas a la función de tu contrato para otorgar el token
        }
    }

    return (
        <div>
            <input 
                type="text" 
                value={contractAddress} 
                onChange={e => setContractAddress(e.target.value)} 
                placeholder="Ingrese la dirección de su contrato"
            />
            <textarea
                value={customABI}
                onChange={e => setCustomABI(e.target.value)}
                placeholder="Ingrese su ABI personalizado (opcional)"
            />
            <button onClick={() => setABI(JSON.parse(customABI || STANDARD_ABI))}>Establecer ABI</button>
            <button onClick={handleButtonClick}>Ver video</button>
        </div>
    );
}

export default App;
