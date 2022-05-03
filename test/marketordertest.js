const Dex = artifacts.require("Dex");
const Link = artifacts.require("Link");
const truffleAssert = require("truffle-assertions");

contract("Dex", accounts => {
    it("should throw an error when creating a market sell order without an adequate token balance", async() => {
        let dex = await Dex.deployed()
        let balance = await dex.balances(accounts[0], web3.utils.fromUtf8("LINK"))
        assert.equal(balance.toNumber(), 0, "Initial LINK balance not 0")

        await truffleAssert.reverts(
            dex.createMarketOrder(1, web3.utils.fromUtf8("LINK"), 10)
        )
    }) 

    it("should throw an error when creating a buy market order without enough ETH", async() => {
        let dex = await Dex.deployed()
        let balance = await dex.balances(accounts[0], web3.utils.fromUtf8("ETH"))
        assert.equal(balance.toNumber(), 0, "Initial ETH balance not 0")

        await truffleAssert.reverts(
            dex.createMarketOrder(0, web3.utils.fromUtf8("LINK"), 10)
        )
    }) 

    it("Market orders can be submitted even if the order book is empty", async() => {
        let dex = await Dex.deployed()
        await dex.deposit({value: 10000})

        let orderbook = await dex.getOrderBook(web3.utils.fromUtf8("LINK"), 0) 
        assert(orderbook.length == 0, "Buy side Orderbook length is not zero")

        await truffleAssert.passes(
            dex.createMarketOrder(0, web3.utils.fromUtf8("LINK"), 10)
        )
    }) 

    it("Market orders should be filled until the order book is empty or the market order is 100% filled", async() => {
        let dex = await Dex.deployed()
        let link = await Link.deployed()

        let orderbook = await dex.getOrderBook(web3.utils.fromUtf8("LINK"), 1) 
        assert.equal(balance.toNumber(), 0, "Initial ETH balance not 0")

        await truffleAssert.reverts(
            dex.createMarketOrder(0, web3.utils.fromUtf8("LINK"), 10)
        )
    }) 






})


