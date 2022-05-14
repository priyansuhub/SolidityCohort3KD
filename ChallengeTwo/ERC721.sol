// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract ERC721Metadata {
    string private name;
    string private symbol;
    constructor(string memory _name, string memory _symbol){
        name = _name;
        symbol =_symbol;
    }
    function nameF() external view returns(string memory){
        return name;
    }
    function symbolF() external view returns(string memory){
        return symbol;
    }
}
contract ERC721{
    event Transfer(
        address indexed from,
        address indexed to,
        uint indexed tokenId
    );
    mapping(uint => address) private _tokenOwner;
    mapping(address => uint) private _ownerTokenCount;
    mapping(uint=>address) private _tokenApprovals;
     //add minting functionality
    function _mint(address _to, uint _tokenId) internal virtual {
        require(_to!= address(0),"0 Address");
        require(_notexists(_tokenId), "User already exists");
        _tokenOwner[_tokenId] = _to;
        _ownerTokenCount[_to]+=1;
        emit Transfer(address(0), _to, _tokenId);
    } 
    function _notexists(uint _tokenId) internal view returns(bool){
        if(_tokenOwner[_tokenId] == address(0)){
            return true;
        }else{
            return false;
        }
    }
    function balanceOf(address _addr) public view returns(uint){
        require(_addr!=address(0), "0 address");
        return _ownerTokenCount[_addr];
    }
    function ownerOf(uint _tokenValue) public view returns(address){
        require(!_notexists(_tokenValue),"0 address");
        return _tokenOwner[_tokenValue];
    }
     function _transferFrom(address _from, address _to, uint256 _tokenId) private{
        require(_to!= address(0),"0 address");
        require(ownerOf(_tokenId)== _from, "not owner buddy");
        _ownerTokenCount[_from]-=1;
        _ownerTokenCount[_to]+=1;
        _tokenOwner[_tokenId]=_to;
    }
    function transferFrom(address _from, address _to, uint _tokenId) public {
        require(_isApprovedOrNot(msg.sender, _tokenId));
        _transferFrom(_from,_to,_tokenId);
    }

    function approve(address _to, uint _tokenId)public{
        address owner = ownerOf(_tokenId);
        require(_to!= owner,"Error approval");
        require(msg.sender == owner,"Not owner");
        _tokenApprovals[_tokenId] = _to;
    }

    function _isApprovedOrNot(address spender, uint tokenId) internal view returns(bool){
        require(!_notexists(tokenId),"token doesnot exists");
        address val = ownerOf(tokenId);
        return(spender == val);
    }
}
contract ERC721Enumerable is ERC721{
    uint[] private _allTokens;
    //token id to position in alltokenaddray
    mapping(uint => uint) private _allTokenIndex;
    //get all the token each address has
    mapping(address => uint[]) private _ownedTokens;
    //token ke array ke andar kaha pe hai
    mapping(uint => uint) private _ownedTokenIndex;

    function totalSupply() public view returns(uint){
        return _allTokens.length;
    }
    function _mint(address _to, uint _tokenId) internal override(ERC721){
        super._mint(_to, _tokenId);
        _addTokensToAllTokenEnumeration(_tokenId);
        _addTokensToOwnerEnumeration(_to,_tokenId);
        //add tokens to the user
    }
    function _addTokensToAllTokenEnumeration(uint tokenId) private{
        _allTokenIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }
    function _addTokensToOwnerEnumeration(address _addr, uint _tknId) private{
        _ownedTokenIndex[_tknId] = _ownedTokens[_addr].length;
        _ownedTokens[_addr].push(_tknId);
    }
    function tokenByindex(uint _index) public view returns(uint){
        require(_index< totalSupply(), "Index out of bound");
        return _allTokens[_index];
    }
    function tokenOfOwnerByIndex(address owner, uint index) public view returns(uint){
        require(index< balanceOf(owner), "Owner idx out of bound");
        return _ownedTokens[owner][index];
    }
    
}
contract ERC721Connector is ERC721Metadata,ERC721{
    constructor(string memory name, string memory id) ERC721Metadata(name, id){

    }
    //JSR
}