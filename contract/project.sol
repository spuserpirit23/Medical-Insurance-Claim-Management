// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MedicalInsuranceClaimManagement {
    address public owner;
    
    // Struct to represent a medical insurance claim
    struct Claim {
        uint256 claimId;
        string patientName;
        uint256 claimAmount;
        string diagnosis;
        bool isProcessed;
        bool isApproved;
    }
    
    uint256 public nextClaimId;
    mapping(uint256 => Claim) public claims;
    mapping(address => uint256[]) public userClaims;

    // Events to log claim processing and approval
    event ClaimSubmitted(uint256 claimId, string patientName, uint256 claimAmount, string diagnosis);
    event ClaimProcessed(uint256 claimId, bool isApproved);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    constructor() {
        owner = msg.sender;
        nextClaimId = 1;
    }

    // Function to submit a new medical insurance claim
    function submitClaim(string memory _patientName, uint256 _claimAmount, string memory _diagnosis) public {
        uint256 claimId = nextClaimId++;
        Claim memory newClaim = Claim({
            claimId: claimId,
            patientName: _patientName,
            claimAmount: _claimAmount,
            diagnosis: _diagnosis,
            isProcessed: false,
            isApproved: false
        });

        claims[claimId] = newClaim;
        userClaims[msg.sender].push(claimId);
        
        emit ClaimSubmitted(claimId, _patientName, _claimAmount, _diagnosis);
    }

    // Function to process a claim (approval/rejection)
    function processClaim(uint256 _claimId, bool _isApproved) public onlyOwner {
        Claim storage claim = claims[_claimId];
        require(!claim.isProcessed, "Claim is already processed.");

        claim.isProcessed = true;
        claim.isApproved = _isApproved;

        emit ClaimProcessed(_claimId, _isApproved);
    }

    // Function to view a claim by its ID
    function viewClaim(uint256 _claimId) public view returns (Claim memory) {
        return claims[_claimId];
    }

    // Function to get all claims for a specific user
    function getUserClaims(address _user) public view returns (uint256[] memory) {
        return userClaims[_user];
    }

    // Function to get the status of a claim (for both the user and the owner)
    function getClaimStatus(uint256 _claimId) public view returns (string memory) {
        Claim storage claim = claims[_claimId];
        if (claim.isProcessed) {
            return claim.isApproved ? "Claim Approved" : "Claim Rejected";
        } else {
            return "Claim Pending";
        }
    }
}

