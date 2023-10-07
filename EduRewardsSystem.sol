// SPDX-License-Identifier: MIT
// Versión de Solidity
pragma solidity ^0.8.0;

// Importar la librería para manejar tokens ERC-20 y ERC-721 (NFTs)
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

// Interfaz extendida para agregar el método 'mint' 
interface IERC721Mintable is IERC721 {
    function mint(address to, uint256 tokenId) external;
}

contract EduRewardSystem {

    address public owner;
    IERC20 public rewardToken;         // Representa el token ERC-20
    IERC721Mintable public nftToken;   // Representa el NFT ERC-721 extendido con 'mint'

    // Mapeo de la actividad a su estado de verificación
    mapping(uint256 => bool) public activityVerified;

    // Evento que se emitirá cuando una actividad sea verificada
    event ActivityVerified(uint256 activityId, address studentAddress);

    constructor(address _rewardToken, address _nftToken) {
        owner = msg.sender;
        rewardToken = IERC20(_rewardToken);
        nftToken = IERC721Mintable(_nftToken);  // Aquí usamos la nueva interfaz
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "No eres el propietario del contrato");
        _;
    }

    // Función para verificar una actividad
    function verifyActivity(uint256 activityId, address studentAddress) external onlyOwner {
        require(!activityVerified[activityId], "Esta actividad ya fue verificada");
        
        activityVerified[activityId] = true;

        // Emitir el evento de actividad verificada
        emit ActivityVerified(activityId, studentAddress);
    }

    // Función para distribuir el token/NFT después de la verificación
    function distributeReward(uint256 activityId, address studentAddress) external onlyOwner {
        require(activityVerified[activityId], "La actividad no ha sido verificada");

        // Transferir el token ERC-20 al estudiante
        rewardToken.transfer(studentAddress, 1);  // Suponiendo que la recompensa es de 1 token
        
        // Asignar un NFT al estudiante
        nftToken.mint(studentAddress, activityId);  // Usando el método 'mint' de nuestra interfaz extendida
    }
}
