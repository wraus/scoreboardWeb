Wheelchair Rugby Scoreboard
=================================================

Wheelchair Rugby Scoreboard is a web based scoreboard that transforms your PC or Mac's display 
into a professional scoreboard that can be used to keep score at games.

By connecting your PC to a large display monitor or projector, 
you can represent a physical scoreboard without additional hardware.

This scoreboard has been designed and customised especially for the sport of **Wheelchair Rugby**.
Once started, the application can be used to display one or multiple scoreboards and controllers.


How it works
-----------------------

1. Download and install the Wheelchair Rugby Scoreboard application from [GitHub](https://github.com/wraus/scoreboardWeb "Wheelchair Rugby Scoreboard")
2. Ensure you have the latest version of Java JDK installed, or download from [here](https://java.com/en/download/ "Oracle Java Download Page")
3. Copy the executable WAR file supplied under folder *dist* to a folder on your PC or MAC.
4. Open a Command or Terminal window and navigate to the folder where the WAR file is installed.
5. Type: **java -jar scoreboard.war** at the command prompt.
6. The scoreboard application will start running on an embedded tomcat web server.
7. Open a browser window and navigate to the URL address: <http://localhost:8080/scoreboard> to display the scoreboard.
8. Open a separate browser window and navigate to the URL address: <http://localhost:8080/scorer> to display the scoreboard controller.
  * In order for the scoreboard and controller timers to function correctly they need to be opened in separate windows and cannot be in an inactive tab.
  * N.B. If the scoreboard or controller window is inactive the timers will be paused until the window/tab is active again.
  * N.B Also, whilst running the application the browser window should not be refreshed or the game will be reset to the start.    
9. Position the scoreboard's display window on the large monitor/projector display for the spectators to see.
10. If additional scoreboards or scoreboard controllers are required simply open in a new browser window.
11. If connecting additional devices see instructions below to share the host PC or MAC 
12. A score.xml log file is produced when the application is started and will record all activity on the scoreboard controller.  

Start scoring your game!

System Requirements
-------------------

To use this template, you will need the following to be already installed on your machine:

- JDK 8 (or above)

Sharing host application to other devices
-----------------------------------------

In some use cases it will be desirable for the Wheelchair Rugby scoreboard application to run on a single host PC and then control scoring from a device such as a tablet or smart phone.   

To enable other devices to connect to your host Wheelchair Rugby application you first need to setup the host PC or MAC as a network hotspot. 

###MAC Configuration###
For configuring a MAC as a Wi-Fi hotspot please follow the instructions at the following [website](http://www.howtogeek.com/214053/how-to-turn-your-mac-into-a-wi-fi-hotspot/)
  
1. The Wi-Fi hotspot option is part of the “Internet Sharing” feature in Mac OS X. You’ll find it in the System Preferences window. Click the Apple menu, select System Preferences, and click the Sharing icon.
2. Select the “Internet Sharing” option in the list. You’ll now need to select the Internet connection you want to share with the devices.
  * N.B The one big limitation is that you can’t both be connected to a Wi-Fi network and host a Wi-Fi network at the same time. (Though you can allow connect via bluetooth)
3. If your Mac is currently connected to the Internet through an Ethernet adapter, select Ethernet in the list at the top of the window and share that wired connection over Wi-Fi. 
4. If you’re tethered to an iPhone via Bluetooth or via a USB cable, you could also select those.
5. In the “To computers using” box, enable the Wi-Fi option. This will create a Wi-Fi hotspot, and the Internet connection you selected at the top of the window will be shared with devices that connect to the Wi-Fi network.
6. Click the “Wi-Fi Options” button at the bottom of the window to configure your Wi-Fi hotspot. Select your preferred network name and the best Wi-Fi channel.
7. Be sure to click the “Security” box and select “WPA2-Personal” and provide a password. 
  * By default, the hotspot will be configured without a password and anyone will be able to connect.
8. In the 'Computer Name' section of Sharing, provide an easy name for other device to connect such as **nickmac** 
9. When you’re done setting things up, click the checkbox to the left of Internet Sharing and click Start to activate your Wi-Fi hotspot.

To connect the other devices simply connect to the Wi-Fi hotspot now discoverable and in a browser window connect to the following URL: <http://nickmac.local:8080/scorer>

You can now control the scoreboard from the attached device.

###Windows Configuration###
For configuring a PC as a Wi-Fi hotspot please follow the instructions at the following [website](http://lifehacker.com/turn-your-windows-10-computer-into-a-wi-fi-hotspot-1724762931)

Windows has a useful feature that allows you to create a virtual Wi-Fi adapter interface. 
This makes it possible to both connect to a Wi-Fi network and create a Wi-Fi hotspot using the same physical network interface at the same time. 
This feature is hidden, but you can access it using the Virtual Router software — this uses the same Windows features as Connectify, a commercial application.



Re- Building the application
---------------------------

If changes are required in the application a new build can be run and distributed.
N.B. To re-build the application you will need to install [maven](https://maven.apache.org/download.cgi "Maven Download")

Run the following `maven` command from the command line in the root directory of your project 
to install and run the application to test changes you have made.

Once started the application as above will be available at the URL: <http://localhost:8080/scoreboard>

```
mvn spring-boot:run
```

N.B The first time you do this, it might take some time as it needs to download library dependencies from a maven repository.


Releases and Deployments
------------------------

###Externalised Configuration###

This application uses the default Spring Boot handling of application configuration properties. As such, you can simply
create an `application.properties` (or yaml) file in the `src/main/resources` directory.

For more information about how Spring Boot externalised configuration works, see [Spring Boot Externalized Config][spring-boot-ext-config].

The following properties are required for EAV connection management and for specifying log location:


    spring.mvc.view.prefix: /WEB-INF/jsp/
    spring.mvc.view.suffix: .jsp
    server.tomcat.access-log-enabled=true
    server.tomcat.access-log-pattern=%h %l %u %t "%r" %s %b %D
    au.org.sports.wrugby.scoreboard.logFile=score.xml

###Deployment###

This application is currently configured for deployment to an embedded tomcat 7 application server. No application container installation is required.

Run the following `maven` command from the command line in the root directory of your project to install

```
mvn clean package
```
