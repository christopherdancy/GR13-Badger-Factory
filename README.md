# GR13-Badger-Factory
Gitcoin GuestList Factory Bounty

Welcome to Remi Colin and Christopher Dancy's submission to GR-13 Badger-Factory bounty.

We took the the time to create a factory for the Guestlist contract utilizing the OpenZeppelin clones factory. 
We also included the ability to initialize the deployed proxy(min)/ clone atomically. After this was completed, we took the time to 
add the ability to pass in a USD denominated max value and the contracts will convert the USD value to the want_token value. 

All tests are ran against a mainnet fork.

`
Create .env from .env.example and add infura private key
brownie test --network mainnet-fork
`
