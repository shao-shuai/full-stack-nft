import React from "react";
import { Box, Buton, Flex, Image, Link, Spacer } from "@chakra-ui/react";
import Facebook from "./assets/social-media-icons/facebook_32x32.png";
import Twitter from "./assets/social-media-icons/twitter_32x32.png";
import Email from "./assets/social-media-icons/email_32x32.png";

const NavBar = ({ accounts, setAccounts }) => {
  const isConnected = Boolean(accounts[0]);

  async function connectAccount() {
    if (window.ethereum) {
      const accounts = await window.ethereum.request({
        method: "eth_requestAccounts",
      });
      setAccounts(accounts);
    }
  }

  return (
    <Flex justify="space-between" align="center" padding="30px">
      <Flex justify="space-around" width="40%" padding="0 75px">
        <Link href="https:www.facebook.com">
          <Image src={Facebook} boxSize="42px" margin="0 15px"/>
        </Link>
        <Link href="https:www.facebook.com">
          <Image src={Twitter} boxSize="42px" margin="0 15px"/>
        </Link>
        <Link href="https:www.facebook.com">
          <Image src={Email} boxSize="42px" margin="0 15px"/>
        </Link>
      </Flex>
      <div>Twitter</div>
      <div>Email</div>
      <div>Abount</div>
      <div>Mint</div>
      <div>Team</div>
      {isConnected ? (
        <p>Connected</p>
      ) : (
        <button onClick={connectAccount}>Connect</button>
      )}
    </Flex>
  );
};

export default NavBar;
