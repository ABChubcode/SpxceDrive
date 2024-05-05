// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Spxce {
    struct User {
        // user id [account address]
        address uid;
        // owned files
        File[] files;
        // files shared with this use [temporarily owned]
        File[] shared;
    }

    struct File {
        // owner of this file
        address owner;
        // ipfs cid pin
        string cid;
        // encryption key | encrypted with the owners public key
        string key;
        // users [addresses] that have access to this address
        address[] accessors;
    }

    // map of address to user
    mapping(address => User) users;

    // map of file cid to file
    mapping(string => File) files;

    function getUser()
        public
        view
        isUserExists(msg.sender)
        returns (address uid)
    {
        return users[msg.sender].uid;
    }

    function isUser() public view returns (bool isuser) {
        isuser = false;
        if (users[msg.sender].uid == msg.sender) {
            isuser = true;
        } else {
            isuser = false;
        }

        return isuser;
    }

    function createUser() public {
        require(users[msg.sender].uid != msg.sender, "USER ALREADY");

        users[msg.sender].uid = msg.sender;
    }

    function getFiles()
        public
        view
        isUserExists(msg.sender)
        returns (File[] memory)
    {
        File[] memory _files = new File[](users[msg.sender].files.length);

        for (uint256 idx = 0; idx < _files.length; idx++) {
            _files[idx] = users[msg.sender].files[idx];
        }

        return _files;
    }

    function getSharedFiles()
        public
        view
        isUserExists(msg.sender)
        returns (File[] memory)
    {
        File[] memory _files = new File[](users[msg.sender].shared.length);

        for (uint256 idx = 0; idx < _files.length; idx++) {
            _files[idx] = users[msg.sender].shared[idx];
        }

        return _files;
    }

    function addFile(string calldata cid, string calldata key) public {
        users[msg.sender].uid = msg.sender;
        address[] memory _accessors = new address[](0);

        users[msg.sender].files.push(File(msg.sender, cid, key, _accessors));
        // files[cid] = File(msg.sender, cid, key);
        files[cid].owner = msg.sender;
        files[cid].cid = cid;
        files[cid].key = key;
    }

    function shareFile(
        address uid,
        string memory cid,
        string memory key
    )
        public
        isUserExists(uid) //  isFileExists(cid)
    //   isFileOwner(cid)
    {
        
        // Add the uid to the list of accessors for the file
        files[cid].accessors.push(uid);

        // Create a new File struct representing the shared file
        File memory sharedFile = File(
            files[cid].owner,
            cid,
            key,
            files[cid].accessors
        );

        for (uint256 idx = 0; idx < users[msg.sender].files.length; idx++) {
            if (keccak256(bytes(users[msg.sender].files[idx].cid)) == keccak256(bytes(cid))) {
                users[msg.sender].files[idx].accessors.push(uid);
                break;
            }
        }

        // Add the shared file to the 'shared' array of the user identified by 'uid'
        users[uid].shared.push(sharedFile);
    }

    modifier isUserExists(address uid) {
        require(users[msg.sender].uid == msg.sender, "USER NOT FOUND");
        _;
    }

    modifier isFileExists(string memory cid) {
        require(
            keccak256(bytes(files[cid].cid)) == keccak256(bytes(cid)),
            "FILE NOT FOUND"
        );
        _;
    }

    modifier isFileOwner(string memory cid) {
        require(files[cid].owner == msg.sender);
        _;
    }
}
//
