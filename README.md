# Kristal-Wii-BIOS-Mod
An attempt at making a mod launcher based on the Wii menu for Kristal

## Channel Icons

![Wii BIOS](https://i.imgur.com/MS8eNNu.png)

The channel icon is the first thing the player will see in your mod. This is the first impression the player will have with your mod if they haven’t seen it on the default Kristal mod select. By default, your channel icon will look like this:
![Default channel](https://i.imgur.com/odiBeYG.png))
However, if your mod has the Wii BIOS library installed, it will look like this:
![Library channel](https://i.imgur.com/hADOo8w.png))
Both of these are only used if your mod does not have its own pre-defined image or frames. To make your own channel icon, you simply need to put wii_channel.png (126x95) in the root of your sprites directory, like so:
![Directory](https://i.imgur.com/jbdRVQz.png))
Doing so will make your mod use the image for its channel. However, it is possible to set your channel to use an animation made of frames instead of a static image. You simply need to do the same thing, except instead of putting a wii_channel.png in your sprites directory, you would put wii_channel_1.png, wii_channel_2.png, etc., until you have all the frames of your animated channel icon in the mod. (In case you’re wondering, frame animation takes priority over a static image.)
So now that you have your frame animation, you might want to change the speed that your channel changes images. To do that, you simply need to make a new file called wii_preview.lua. This file can either be placed in your mod root or your mod’s preview folder. From there, set up your file like so:
![Animation](https://i.imgur.com/aSFCmYj.png)
For this example, the images will change every 1/15 seconds.
There is one more thing you can do with the channel icon. You can code a preview for it. Previews are coded in a similar way to the default mod preview, but it does have a few differences.
![https://i.imgur.com/khpYxr3.png](iconInit)
iconInit() is meant to create the assets and variables your code will use. You will put everything included with the preview in a data table; this is important, as these items will be used for the rest of the preview.
![https://i.imgur.com/FWog7yV.png](iconUpdate)
iconUpdate(data, timer) is used to update the variables in your preview. The data table passed into this function is the exact same one you returned in iconInit(). Be sure to return an updated version of the data table.
![https://i.imgur.com/39cLH6I.png](iconDraw)
iconDraw(data, timer) is basically the same thing, except instead of updating everything, you will be drawing it. You also don’t need to return a data table.

## Wii BIOS Library
The Wii BIOS Library is an add-on tool to the Wii BIOS Mod which lets you send messages to the Wii Message Board. To send a message using it, first, you have to make sure it is installed. Then, you want to run the following code, making sure you replace the values with your own values:
![https://i.imgur.com/QA2w30o.png](Message)
The first parameter of the messageBoard event is the message you wish to send, and the second parameter is the title. The title is optional, as it will default to your mod’s name.

## Wii Mode
To detect whether Kristal is in “Wii Mode” or not, simply check if Kristal.load_wii is true or false. If it is true, Kristal is in Wii Mode.

## Wii Save
The Wii BIOS overrides your save to use the simple save menu. However, if you have an object called "WiiSaveMenu", you can set your own.
