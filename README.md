# Poker bot BEARL

This Poker bot is the result of a school project I carried with 4 other students. The main objective was to get a code as robust as possible.

## Context

The Bot is adapt to interact with a slightly modified version of [TheAIGame's poker environment](github.com/theaigames/poker-engine).

## Strategy

During the limited time provided by the engine to act during the party, the bot try to evaluate the power of its hand by simulating all comming cards possibilities. To achieve a descent calculation time,  Monte Carlo algorithm has been used. Several tests have been done trough Python scripts to optimize the card generation order and find the perfect balance between calculation time and precision.