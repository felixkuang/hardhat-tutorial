// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MultisigWallet {
    event Deposit(address indexed sender,uint amount); // Deposit event  存款事件
    event Submit(uint indexed txId); // Submit transaction request event 提交交易申请
    event Approve(address indexed owner,uint indexed txId); // Approval of the event 由合约签名人批准
    event Revoke(address indexed owner,uint indexed txId); //Cancel the approval 撤销批准，交易未提交之前可以撤销
    event Execute(uint indexed txId); // Execute event 执行交易

    // 交易数据由签名人发起提议，由其他签名人同意批注它，最后完成交易
    struct Transaction{
        address to;
        uint value;
        bytes data;
        bool executed;
    }

    address[] public owners;    // 合约所有签名人，合约可能有多个签名人
    mapping(address=>bool) public isOwner;  // 查找用户是不是签名人其中的一个地址，如果true则是合约中的签名人
    uint public required; //Confirmation number 最少要满足确认数的签名人同意，这笔钱才能转出

    Transaction[] public transactions;  // 交易数组
    mapping(uint => mapping(address => bool)) public approved;  //交易id对应了交易数组的索引值， 记录某一笔交易之下的签名人的地址是否同意了这次交易

    modifier onlyOwner() {
        require(isOwner[msg.sender],"not owner");
        _;
    }
    // 判断交易id 是否存在
    modifier txExists(uint _txId){
        require(_txId < transactions.length,"tx does not exist");
        _;
    } 
    // 判断签名人是否已经批准
    modifier notApproved(uint _txId){
        require(!approved[_txId][msg.sender],"tx already approved");
        _;
    }
    // 判断交易不能是执行过的交易
    modifier notExecuted(uint _txId){
        require(!transactions[_txId].executed,"tx already executed");
        _;
    }
    /**
    * @param _owners 签名人地址数组
    * @param _required 签名人地址最小确认数
    **/
    constructor(address[] memory _owners, uint _required){
        require(_owners.length > 0, "owners required"); // 确认地址数组长度>0
        require(_required > 0 && _required <= _owners.length, "invalid required number of owners"); // 确认数大于0并且小于等于地址数组长度

        // 判断是否是有效地址
        for (uint i; i < _owners.length;i++){
            address owner = _owners[i];
            require(owner != address(0),"invalid owner");
            require(!isOwner[owner],"owner is not unique"); // 判断地址不能是一个已经添加过的地址

            isOwner[owner] = true;
            owners.push(owner);
        }

        required = _required;
    }

    receive() external payable{
        emit Deposit(msg.sender,msg.value);
    }
    
    // 交易只能有签名人提交
    function submit(address _to,uint _value, bytes calldata _data) external onlyOwner{
        transactions.push(Transaction({
            to: _to,
            value: _value,
            data: _data,
            executed: false
        }));
        emit Submit(transactions.length - 1);
    }

    // 批准
    function approve(uint _txId) 
        external 
        onlyOwner
        txExists(_txId)
        notApproved(_txId)
        notExecuted(_txId)
    {
        approved[_txId][msg.sender] == true;
        emit Approve(msg.sender,_txId);
    }

    // 获取批准数量
    function _getApprovalCount(uint _txId) private view returns(uint count){

        for(uint i=0; i<owners.length; i++){
            if(approved[_txId][owners[i]]){
                count += 1;
            }
        }
    }

    // 执行交易
    function execute(uint _txId) external txExists(_txId) notExecuted(_txId){
        require(_getApprovalCount(_txId) >= required, "approvals < required");
        Transaction storage transaction = transactions[_txId];

        transaction.executed = true;

        (bool success,)=transaction.to.call{value: transaction.value}(
            transaction.data
        );

        require(success,"tx failed");
        emit Execute(_txId);
    }

    // 撤销批准
    function revoke(uint _txId) 
        external 
        onlyOwner 
        txExists(_txId)
        notExecuted(_txId)
    {
        require(approved[_txId][msg.sender],"tx not approved");
        approved[_txId][msg.sender] = false;
        emit Revoke(msg.sender,_txId);
    }
}