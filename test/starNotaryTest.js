import 'babel-polyfill'; // Sometimes web pack throws an error if this import is not added
const StarNotary = artifacts.require('./StarNotary.sol')

let instance;
let accounts;

contract("StarNotary tests", async (accs) => {
    accounts = accs;
    instance = await StarNotary.deployed();
});

it("Can create a star", async () => {
    let starName = "TestStar";
    let tokenID = 1;

    await instance.createStar(starName, tokenID, {from: accounts[0]}); // The third parameter is implicit
    let createdStarName = await instance.tokenIDtoStar.call(tokenID).name; // This is an async call
    assert.equal(createdStarName, starName);
})

it("A user can put up for sale a star", async () => {
    let user = accounts[1];
    let starID = 2;
    let starPrice = web3.toWei(.01, "ether"); // web3 is available automatically

    // Proceed to create a star
    await instance.createStar("TestStar", starID, {from: user});

    // Put the star up for sale
    await instance.putStarForSale(starID, starPrice, {from: user});

    // Get the star from the starForSale object, this is an async call
    let starForSalePrice = await instance.starForSale.call(starID)

    assert.equal(starForSalePrice, starPrice)
})

it("Given a start when a user buys a star, then original owner gets the funds", async () => {
    let originalOwner = accounts[1];
    let buyer = accounts[2];

    let starID = 3;

    let starPrice = web3.toWei(.01, "ether");

    // Original owner creates a star
    await instance.createStar("TestStar", starID, {from: originalOwner});

    // Original owner puts the star for sale
    await instance.putStarForSale(starID, starPrice, {from: originalOwner});

    /*
    * Questions:
    * 1) How can I calculate the transaction fee?
    * 2) How can I grab the original owner's account balance?
    * */

    // For 2)
    let originalOwnerBalanceBeforeTransaction = web3.eth.balance(originalOwner);

    // Buyer buys the star
    await instance.buyStar(starID, {from: buyer}); // For 1) we can specify the gas price inside the third argument

    // Grab the original owner balance after the transaction;
    let originalOwnerBalanceAfterTransaction = web3.eth.balance(originalOwner);

    assert.equal(originalOwnerBalanceBeforeTransaction.add(starPrice).toNumber(), originalOwnerBalanceAfterTransaction);
})

// Other tests are similar
