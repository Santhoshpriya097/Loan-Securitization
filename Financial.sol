 pragma solidity ^0.4.13;
import "./LoanToken.sol";
contract Financial
{
    struct bank_Details
    {
        string name;
        uint256 bal;
        uint256 time;
        uint256 loan_interst;
        uint256 fi_id;
        uint256 filn_id;
    }
    struct loanaddress
    {
        address spv;
        address invs;
    }
     mapping(address=>bank_Details) public bank_d1;
     mapping(uint256=>loanaddress) public loanadd;
     mapping (address=>mapping(uint256=>loan_get))public ln_get;
     mapping(address=>uint256)public ln_get_id;
     mapping(address=>uint256)public packln_get_id;
     mapping (address=>mapping(uint256=>package))public packagedetail;
     mapping(address=>spv_detail)public spv_details;
     mapping(address=>Investor)public investor_details;
     mapping(uint256 => mapping(uint256 =>uint256))public packageivd;
     address[] public spv_reg;
     address[] public invs_reg;
     address[]  reg_user;
     uint256 loan_id = 101;
     uint256 spvloanid=1001;
     uint256 packageid=10001;
     uint256 invespackid=100001;
     uint256 bank_take_interest;
     uint256 spv_take_interest;
     uint256 spvamount;
     //uint256 public fi_1;
     //uint256 public spv_1;
     //uint256 public inv_1;
    function register(string name,uint _loan_interst,uint _time)public payable
    {
        if(bank_d1[msg.sender].time == 0)
        {
            bank_d1[msg.sender].name = name;
            bank_d1[msg.sender].loan_interst = _loan_interst;
            bank_d1[msg.sender].bal = msg.value;
            bank_d1[msg.sender].time = _time;
            bank_d1[msg.sender].fi_id =loan_id ;
            bank_d1[msg.sender].filn_id =loan_id ;
            reg_user.push(msg.sender);
            loan_id=loan_id+100;
        }
    }
    function show_registers() public view returns(address[])
    {
        return reg_user;
    }
    function fetchBalance(address _banker) public constant returns (uint256)
    {
        return bank_d1[_banker].bal;
    }
    function isRegistered(address _bank) public constant returns (bool) {
      return bank_d1[_bank].time > 0;
    }
    struct loan_get
    { 
        uint256 id;
        uint256 token;
        string token_symbol;
        address bank_address;
        address borr_address;
        uint256 amount;
        uint256 count;
        uint last_setl_time;
        uint time;
        uint months;
        uint bal_ln;
        uint installment;
        uint256 spvid;
        address token_address;       
    }
    struct loan_pro
    {
        address bank_address;
        uint256 amount;
        uint time;
        uint months;
    }
     struct spv_detail
    {
            uint256 initial_spv_ether;
            uint256 spv_loan;
            uint256 spv_send_ether;
            uint256 available_pack;
            uint256 send_pack;
            uint256 spvid;
            uint256 spvlnid;
            uint256 packln_id;
            uint256 packid;
    }
    struct package
    {
        uint256 package_id;
        uint256 totalvalue;
        uint256 totalloan;
        uint256 packln;
        uint256 spvpack;
    }
    struct Investor
    {
            uint256 Investor_ether;
            uint256 Investor_package;
            uint256 Invsid;
            uint256 invslnid;
    }
    function req_loan(address _token,address bank_address,uint256 tokenvalue,string tokensymbol) public //payable   // add token_symbol
    {   
        uint256 amt = ((tokenvalue * 1 ether)*80 / 100);
        require(bank_d1[bank_address].time!=0);
        require(bank_address!=msg.sender);
        require (bank_d1[bank_address].bal > amt );
        LoanToken(_token).transferFrom(msg.sender,bank_address,tokenvalue);
        bank_d1[bank_address].bal -= amt;
        loan_id++;
        ln_get_id[msg.sender] =  bank_d1[bank_address].fi_id;
        ln_get_id[bank_address] =  bank_d1[bank_address].fi_id;
        ln_get[msg.sender][ln_get_id[msg.sender]].bank_address = bank_address;
        ln_get[msg.sender][ln_get_id[msg.sender]].amount = amt;
        ln_get[msg.sender][ln_get_id[msg.sender]].months=12;
        ln_get[msg.sender][ln_get_id[msg.sender]].time=now;
        ln_get[msg.sender][ln_get_id[msg.sender]].last_setl_time=now;
        ln_get[msg.sender][ln_get_id[msg.sender]].installment=(amt)/(12);
        ln_get[msg.sender][ln_get_id[msg.sender]].bal_ln = amt;
        ln_get[msg.sender][ln_get_id[msg.sender]].id = ln_get_id[msg.sender];
        ln_get[msg.sender][ln_get_id[msg.sender]].token = tokenvalue;
        ln_get[msg.sender][ln_get_id[msg.sender]].token_symbol = tokensymbol;
        ln_get[msg.sender][ln_get_id[msg.sender]].token_address=_token;
        ln_get[msg.sender][ln_get_id[msg.sender]].borr_address=msg.sender;
        //bank storage//
        ln_get[bank_address][ln_get_id[bank_address]].bank_address = bank_address;
        ln_get[bank_address][ln_get_id[bank_address]].amount = amt;
        ln_get[bank_address][ln_get_id[bank_address]].months=12;
        ln_get[bank_address][ln_get_id[bank_address]].time=now;
        ln_get[bank_address][ln_get_id[bank_address]].last_setl_time=now;
        ln_get[bank_address][ln_get_id[bank_address]].installment=(amt)/(12);
        ln_get[bank_address][ln_get_id[bank_address]].bal_ln = amt;
        ln_get[bank_address][ln_get_id[bank_address]].id = ln_get_id[msg.sender];
        ln_get[bank_address][ln_get_id[bank_address]].token = tokenvalue;
        ln_get[bank_address][ln_get_id[bank_address]].token_symbol = tokensymbol;
        ln_get[bank_address][ln_get_id[bank_address]].token_address = _token;
        ln_get[bank_address][ln_get_id[bank_address]].borr_address=msg.sender;
        msg.sender.transfer(amt * 1 wei);
        bank_d1[bank_address].fi_id= bank_d1[bank_address].fi_id+1;
    }
    function balanceOftoken(address _token) public view returns(uint)
    {
        return LoanToken(_token).balanceOf(msg.sender);
    }
    function settlement(uint256 ln_id,address fiaddress) public payable
    {
       require(ln_get[msg.sender][ln_id].count<ln_get[msg.sender][ln_id].months);
        uint temp_bal_ln=ln_get[msg.sender][ln_id].bal_ln;
        uint temp_ins=ln_get[msg.sender][ln_id].installment;
        uint temp_last=ln_get[msg.sender][ln_id].last_setl_time + 1 minutes;//30 days;
       uint intr=bank_d1[fiaddress].loan_interst;
        uint amt=( temp_bal_ln * (intr/100) ) ;
        uint256 amont=temp_ins+amt;
        ln_get[msg.sender][ln_id].last_setl_time = temp_last +1 minutes;//30 days;
        ln_get[fiaddress][ln_id].last_setl_time = temp_last +1 minutes;//30 days;
        ln_get[msg.sender][ln_id].bal_ln-=temp_ins;
        ln_get[fiaddress][ln_id].bal_ln-=temp_ins;
        ln_get[msg.sender][ln_id].count++;
        ln_get[fiaddress][ln_id].count++;
       if(ln_get[fiaddress][ln_id].id>0&&ln_get[loanadd[ln_id].spv][ln_id].id>0&&packagedetail[loanadd[ln_id].invs][ln_id].packln>0)         
        {
        bank_take_interest=(amont *10)/100;
        bank_d1[fiaddress].bal +=bank_take_interest;
        spv_take_interest=((amont-bank_take_interest)*10)/100;
        spv_details[loanadd[ln_id].spv].initial_spv_ether +=spv_take_interest;
        uint256 balance_investor_amount=amont- (bank_take_interest+spv_take_interest);
        investor_details[loanadd[ln_id].invs].Investor_ether += balance_investor_amount;
        } 
       else if(ln_get[fiaddress][ln_id].id>0&&ln_get[loanadd[ln_id].spv][ln_id].id>0) 
         {
        bank_take_interest=(amont *10)/100;
        bank_d1[fiaddress].bal +=bank_take_interest;
        spvamount=amont-bank_take_interest; 
        spv_details[loanadd[ln_id].spv].initial_spv_ether +=spvamount;
        }
       else         
        {
              bank_d1[fiaddress].bal +=amont;
        }
    }
    function SPV_ether()public payable
    {
        if( spv_details[msg.sender].initial_spv_ether == 0)
        {
         spv_details[msg.sender].initial_spv_ether=msg.value;
         spv_details[msg.sender].spv_send_ether=0;
         spv_details[msg.sender].spvid=spvloanid;
         spv_details[msg.sender].spvlnid=spvloanid;
         spv_details[msg.sender].packln_id=packageid;
         spv_details[msg.sender].packid=packageid;
         packageid=packageid+10000;
         spvloanid=spvloanid+1000;
         spv_reg.push(msg.sender);
        }
    }
    function spv_registers() public view returns(address[])
    {
        return spv_reg;
    }
    function spvRegistered(address _spvad) public constant returns (bool) {
      return spv_details[_spvad].initial_spv_ether > 0;
    }
    function spvBalance(address _spv) public constant returns (uint256)
    {
        return spv_details[_spv].initial_spv_ether;
    }
    function spvloancheck(uint256 loanid)public view returns(bool)
    {
        return loanid!=ln_get[msg.sender][loanid].id;
    }
    function purchase_loan(uint256 loanId,address FI)public payable   //purchase_loan(uint256 loan_id[])
    {
          
                loanadd[loanId].spv=msg.sender;
               ln_get_id[msg.sender] =spv_details[msg.sender].spvlnid;
               ln_get[msg.sender][ln_get_id[msg.sender]].spvid=ln_get_id[msg.sender];
               ln_get[msg.sender][ln_get_id[msg.sender]].bank_address = ln_get[FI][loanId].bank_address;
               ln_get[msg.sender][ln_get_id[msg.sender]].amount = ln_get[FI][loanId].amount;
               ln_get[msg.sender][ln_get_id[msg.sender]].months=ln_get[FI][loanId].months;
               ln_get[msg.sender][ln_get_id[msg.sender]].time=ln_get[FI][loanId].time;
               ln_get[msg.sender][ln_get_id[msg.sender]].last_setl_time=ln_get[FI][loanId].last_setl_time;
               ln_get[msg.sender][ln_get_id[msg.sender]].installment=ln_get[FI][loanId].installment;
               ln_get[msg.sender][ln_get_id[msg.sender]].bal_ln = ln_get[FI][loanId].bal_ln;
               ln_get[msg.sender][ln_get_id[msg.sender]].id =ln_get[FI][loanId].id;
               ln_get[msg.sender][loanId].id =ln_get[FI][loanId].id;
               ln_get[msg.sender][ln_get_id[msg.sender]].token_address =ln_get[FI][loanId].token_address;
               ln_get[msg.sender][ln_get_id[msg.sender]].token =ln_get[FI][loanId].token;
               ln_get[msg.sender][ln_get_id[msg.sender]].token_symbol =ln_get[FI][loanId].token_symbol;
               ln_get[msg.sender][ln_get_id[msg.sender]].token_address =ln_get[FI][loanId].token_address;
               ln_get[msg.sender][ln_get_id[msg.sender]].borr_address=ln_get[FI][loanId].borr_address;
               spv_details[msg.sender].initial_spv_ether-=ln_get[FI][loanId].amount;
               bank_d1[FI].bal+=ln_get[FI][loanId].amount;
               LoanToken(ln_get[FI][loanId].token_address).transferFrom(FI,msg.sender,ln_get[FI][loanId].token);  
               spv_details[msg.sender].spvlnid=spv_details[msg.sender].spvlnid+1;
               spv_details[msg.sender].spv_loan=(spv_details[msg.sender].spvlnid)-spv_details[msg.sender].spvid;
    }
    function Investor_ether()public payable
        {
         invs_reg.push(msg.sender);
         investor_details[msg.sender].Investor_ether=msg.value;
         investor_details[msg.sender].Invsid=invespackid;
         investor_details[msg.sender].invslnid=invespackid;
         invespackid=invespackid+100000;
        }
    function investerRegistered(address _investadd) public constant returns (bool) 
        {
      return investor_details[_investadd].Investor_ether > 0;
    }
    function investerBalance(address _invest) public constant returns (uint256)
    {
        return investor_details[_invest].Investor_ether;
    }
    function createPacking(uint256[] _loanId)public //returns(uint256[])
    {
            uint256 totalTokenCost=0;
           packln_get_id[msg.sender]= spv_details[msg.sender].packid;
            for(uint256 a=0;a<_loanId.length;a++)
            {
                totalTokenCost+=ln_get[msg.sender][_loanId[a]].amount;
                packageivd[packln_get_id[msg.sender]][a]=_loanId[a];
            }
           packagedetail[msg.sender][packln_get_id[msg.sender]].package_id=packln_get_id[msg.sender];
           packagedetail[msg.sender][packln_get_id[msg.sender]].totalvalue=totalTokenCost;
           packagedetail[msg.sender][packln_get_id[msg.sender]].totalloan=_loanId.length;
           spv_details[msg.sender].packid=spv_details[msg.sender].packid+1;
           spv_details[msg.sender].available_pack=spv_details[msg.sender].packid-spv_details[msg.sender].packln_id;
    }
     function invsloancheck(uint256 packageindex)public view returns(bool)
    {
        return packageindex!= packagedetail[msg.sender][packageindex].spvpack;
    }
    function purchase_pack(uint256 _packindex,address choosespvadd)public 
    {
                 uint256 totalpackagevalue=0;
                for(uint256 b=0;b<packagedetail[choosespvadd][_packindex].totalloan;b++)
                {
                     loanadd[ln_get[choosespvadd][packageivd[_packindex][b]].id].invs=msg.sender;
                    packagedetail[msg.sender][ln_get[choosespvadd][packageivd[_packindex][b]].id].packln=ln_get[choosespvadd][packageivd[_packindex][b]].id;
                    LoanToken(ln_get[choosespvadd][packageivd[_packindex][b]].token_address).transferFrom(choosespvadd,msg.sender, ln_get[choosespvadd][packageivd[_packindex][b]].token);
                }
            totalpackagevalue+=packagedetail[choosespvadd][_packindex].totalvalue;
            packagedetail[msg.sender][_packindex].spvpack=_packindex;
            packln_get_id[msg.sender]=investor_details[msg.sender].invslnid;
            packagedetail[msg.sender][packln_get_id[msg.sender]].package_id=packln_get_id[msg.sender];
            packagedetail[msg.sender][packln_get_id[msg.sender]].totalvalue=totalpackagevalue;
            spv_details[choosespvadd].initial_spv_ether+=packagedetail[msg.sender][packln_get_id[msg.sender]].totalvalue;
            investor_details[msg.sender].Investor_ether-=packagedetail[msg.sender][packln_get_id[msg.sender]].totalvalue;
            investor_details[msg.sender].invslnid=investor_details[msg.sender].invslnid+1;
            investor_details[msg.sender].Investor_package=investor_details[msg.sender].invslnid-investor_details[msg.sender].Invsid;
    }
}
