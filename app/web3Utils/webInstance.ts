"use client";
import Web3 from 'web3';



const web3Instance = new Web3((global?.window as any)?.ethereum ? (global?.window as any)?.ethereum: "https://sepolia-rpc.scroll.io");

export default web3Instance;