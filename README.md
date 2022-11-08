<img width="85" alt="83 5@2x" src="https://user-images.githubusercontent.com/38206129/164548260-c8cb6992-b363-4902-81dd-8c20ce879adf.png">

#  Solanyte 


A mobile wallet tracking application for iOS.

### Usage
- Gives extended description of each coin (powered by Coingecko)
- Tracks token accounts of wallet
- Stores multiple wallet addresses
- Stores balance of current wallet

### Powered by:
- Solana
- Coingecko
- Solscan

## Usage

| Functionality  | Screenshot |
| ------------- | ------------- |
| Add your solana wallet. No need to authorize with your seed phrase. You can look through your balance by just typing the address  | <img src="https://user-images.githubusercontent.com/38206129/194151634-f439b8f0-b032-4784-b4a0-dcd511213934.png" alt="simulator_screenshot_280D01EA-FF14-4530-B670-DDCD58057E11" width="600">  |
| From now on you can track your balance and coins of your wallet. It is saved in device memory, so no need to enter the address again. Sorting, filtering is allowed as well for better experience. Current wallet balance is also stored, so you may see the difference of balances from the very first moment when you started tracking certain wallet  | <img src="https://user-images.githubusercontent.com/38206129/194152029-2e6c87a9-85c0-47fc-a014-cd8eedbafa0e.png" alt="simulator_screenshot_0191A6B9-856F-4DD5-B0B1-0435601678E0" width="600">  |
| Browse through coins to find something new about the technology. Additionally, you may find top holders of each coin and start tracking them. You may switch between wallets in wallet tab and start over again  | <img src="https://user-images.githubusercontent.com/38206129/194152402-00d2721d-3247-4e6d-b74c-fda1980811e0.png" alt="simulator_screenshot_0191A6B9-856F-4DD5-B0B1-0435601678E0" width="600">  |
| Special thanks to those who are named here :)  | <img src="https://user-images.githubusercontent.com/38206129/194152615-51c28883-3ed5-4167-91a4-c0823910822f.png" alt="simulator_screenshot_0191A6B9-856F-4DD5-B0B1-0435601678E0" width="600">  |

-----------
### Roadmap
- [x] finish design of add wallet
- [x] finish design of setting menu
- [x] add Solscan branding
- [x] add Solana branding
- [x] add remove all core data banner
- [x] show stats of portfolio on main screen
- [x] adjust wallet reconnection
- [x] add toggle to hide zero-balances
- [x] store wallet address or multiple
- [x] fetch no-portfolio-coins after removing a wallet
- [x] pop up to accept removing wallet
- [x] add tabs
- [x] add possibility of multiple wallets (mb add new field to wallet entity and store coin gecko IDs there along with token addresses, and make wallets multiple, lets say up to 3 wallets)
- [x] get holders for each coin
- [x] redefine view models and services for new architecture
- [x] change portfolio data service to store multiple wallets
- [ ] add error handling
- [ ] check if api responds (if no - show error)
- [ ] add create wallet link in portfolio view
- [ ] track transactions ?
- [ ] tests
- [ ] other devices' widgets
