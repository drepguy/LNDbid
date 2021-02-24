# LNDbid
LNDbid addon from Guild Legends Never Die to auto bid in Raidchat. Create a directory LNDbid in addons folder of your WoW Installation and copy files in this new directory.
# Install
Copy files in ..\World of Warcraft\_classic_\Interface\Addons\LNDbid
## Usage
Open the bid window with /bid or /lndb. Enter your Min DKP Value and your Max DKP Value. You can also preset the values with the command "/dkp mindkp maxdkp". Click start to start bidding process. If someone bids before you started the process the value in Min DKP will be set automatically. Then you just have to set the Max DKP Value and start the process.  
## Restrictions
This Addon depends upon full bidding in Raidchat. If someone bids in a hidden manner or in the wrong chat this addon can't overbid. If someone doesnt bid in usual manner, the addon will misinterpret the numbers. E.g. a space between digits (100 0 is interpreted as 100 and not as 1000). If someone uses number abrevations like k the parsing will also fail (1k is not interpreted as 1000).
