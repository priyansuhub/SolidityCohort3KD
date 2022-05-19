
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./NFTPri.sol";
contract Staking is ERC20{
    NFTPri myNFT;
    uint constant SECONDS_PER_DAY = 24 * 60 * 60;
    uint constant BASE_YIELD_RATE = 100 ether;
    struct Staker{
        uint currYield;
        uint reward;
        uint lastCheckpoint;
        uint[] tokenId;
    }
    mapping(uint => address) public originalOwner;
    mapping (address => Staker) public stakers;
    constructor(address _nftContract) ERC20("Priyansu","PRK"){
        myNFT = NFTPri(_nftContract);
    }
    function stake(uint[] memory _tokenId) public{
         Staker storage user = stakers[msg.sender];
         uint yield = user.currYield;
         uint length = _tokenId.length;
         for(uint i = 0 ; i< length; i++){
            require(myNFT.ownerOf(_tokenId[i]) == msg.sender, "Not owner");
            originalOwner[i] = msg.sender;
            myNFT.safeTransferFrom(msg.sender, address(this), _tokenId[i]);
            yield += BASE_YIELD_RATE;
         }
         accumulate(msg.sender);
         user.currYield = yield;
    }
    function unstake(uint[] memory _tokenId) public{
        Staker storage user = stakers[msg.sender];
         uint yield = user.currYield;
         uint length = _tokenId.length;
         for(uint i = 0 ; i< length; i++){
            require(myNFT.ownerOf(_tokenId[i]) == msg.sender, "Not owner");
            if(yield!=0){
                 yield -= BASE_YIELD_RATE;
            }
            myNFT.safeTransferFrom(address(this),msg.sender,  _tokenId[i]);
            originalOwner[i] = address(0);
         }
         accumulate(msg.sender);
         user.currYield = yield;
    }
    function claim() public{
        Staker storage user = stakers[msg.sender];
        accumulate(msg.sender);

        _mint(msg.sender, user.reward);
        user.reward = 0;
    }
    function accumulate(address _staker) public {
        stakers[_staker].lastCheckpoint = block.timestamp;
        stakers[_staker].reward += getRewards(_staker);
    }
    function getRewards(address _staker) public view returns(uint){
        Staker memory user = stakers[_staker];
        if(user.lastCheckpoint == 0){
            return 0;
        }
        return ((block.timestamp - user.lastCheckpoint) * user.currYield)/SECONDS_PER_DAY;
    }
}