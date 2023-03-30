# Apple Music API app
Simple iOS app that allows to search for songs in the Apple Music servers, get some details about them and their artists.
The aim of this project was to get familiar with Apple Music API and Combine framework, used to make multiple calls, one depending from the other.

## Technologies
This app was developed thanks to the following technologies:
1. Apple Music API
2. Combine framework

## Combine
Thanks to this framework we are able to fetch songs as the user writes the input. As soon as the songs are fetched, for each of them another API call is made. This way, if the user wants more details about the songs they are quickly available for the user.
