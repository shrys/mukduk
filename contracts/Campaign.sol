    pragma solidity ^0.4.17;

    contract Campaign {
        struct Request {
            string description;
            uint value;
            address recipient;
            bool complete;
            uint approvalCount;
            mapping(address => bool) apporvals;
        }
        
        Request[] public requests;
        address public manager;
        uint public minimumContributuion;
        mapping (address=>bool) public approvers;

        modifier restricted() {
            require(msg.sender == manager);
            _;
        }
        
        constructor(uint minimum) public {
            manager = msg.sender;
            minimumContributuion = minimum;
        }
        
        function contribute() public payable {
            require(msg.value > minimumContributuion);
            
            approvers[msg.sender] = true;
        }

        function createRequest(string description, uint value, address recipient)
        public restricted {
            // require(approvers[msg.sender]);
            Request memory newRequest = Request(description, value, recipient, false, 0);

            requests.push(newRequest);
        }

        function approveRequest(uint index) public {
            Request storage request = requests[index];

            require(approvers[msg.sender]);
            require(!request.apporvals[msg.sender]);
            
            request.apporvals[msg.sender] = true;
            request.approvalCount++;
        }
    }