/*

awPull 2019:by Keff Edwards

awPull is a Processing3 Sketch that allows you to pull weather data from an Ambiant Weather ipObserver.

Uses the apache commons lang3 library so you will need to download that and put it in your processing library.

*/


import processing.net.*; 
import org.apache.commons.lang3.StringUtils;
import java.text.SimpleDateFormat;
import java.util.Date;


Client c; 
int nextUpdate;
PrintWriter output;
String settings[] = new String[10];

//Time Stamp Generation Class  
public static String getCurrentTimeStamp(String type) {
    if (type.equals("ms")){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
         Date now = new Date();
        String strDate = sdf.format(now);
        return strDate;
    }else{
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date now = new Date();
        String strDate = sdf.format(now);
        return strDate;
    }
}   

void setup() { 
  loadConfig();
  size(200, 200); 
  background(50); 
  fill(200);
  output = createWriter(settings[8] + settings[9] + year() + month() + day() + "_" + hour() + minute() + second() + ".csv");
  output.println("SYS_TimeStamp,SVR_TimStamp,Indoor_Channel,Indoor_Battery,Outdoor_Channel,Outdoor_Battery,Second_Outdoor_Channel,Second_Outdoor_Battery,Indoor_Temp,Indoor_Hum,Abs_Press,Rel_Press,Outdoor_Temp,Outdoor_Hum,Wind_Dir,Wind_Speed,Wind_Gust,Max_Daily_Gust,SolRad,Uv,Uvi,PM2_5,Hour_Rain,Event_Rain,Daily_Rain,Weekly_Rain,Monthly_Rain,Yearly_Rain");
} 

void draw() {
   if (nextUpdate < millis()){
       boolean newData = false;
       String data = "";
       
       c = new Client(this, settings[1], 80);  // ipObserver
       c.write("GET /livedata.htm HTTP/1.0\n");  // "GET" live data page from 
       nextUpdate = millis() + int(settings[7]);  //set next sample time.
       
       delay(1000);
       
       while (c.available() > 0) {    // Read data coming from into the client....
           data += c.readString();   // ...and put it in a String
           newData = true;  //Hey, we got some new data.
       
        } 
                      
       if (newData == true) {   //If there is some new data lets do something with it.
            String[] lines = data.split(System.getProperty("line.separator"));    // I am going to split it up into lines so it is easier to manage.
            String[] wx_e = new String[27];
            if (lines.length == 243) {  //Before I start reading the array I want to make sure all the data is here, a good data grab shoud produce 243 elements
            wx_e[0] = (StringUtils.substringBetween(lines[53], "value=\"","\" maxlength="));  //Time:  Does not output seconds, duh!  What were yall thinking.
            wx_e[1] = (StringUtils.substringBetween(lines[59], "value=\"","\" maxlength="));  //Indoor Sensor Channel Number
            wx_e[2] = (StringUtils.substringBetween(lines[60], "value=\"","\" maxlength="));  //Indoor Sensor Battery Level
            wx_e[3] = (StringUtils.substringBetween(lines[66], "value=\"","\" maxlength="));  //OutDoot Sensor Channel Number
            wx_e[4] = (StringUtils.substringBetween(lines[67], "value=\"","\" maxlength="));  //OutDoor Sensor Battery Level
            wx_e[5] = (StringUtils.substringBetween(lines[73], "value=\"","\" maxlength="));  //Second OutDoor Sensor Channel Number
            wx_e[6] = (StringUtils.substringBetween(lines[74], "value=\"","\" maxlength="));  //Second OutDoor Sensor Battery Level
            wx_e[7] = (StringUtils.substringBetween(lines[80], "value=\"","\" maxlength="));  //Indoor Temp
            wx_e[8] = (StringUtils.substringBetween(lines[85], "value=\"","\" maxlength="));  //Indoor Humidity
            wx_e[9] = (StringUtils.substringBetween(lines[89], "value=\"","\" maxlength="));  //Absolute Pressure
            wx_e[10] = (StringUtils.substringBetween(lines[93], "value=\"","\" maxlength="));  //Reletive Pressure
            wx_e[11] = (StringUtils.substringBetween(lines[97], "value=\"","\" maxlength="));  //Outdoor Temp
            wx_e[12] = (StringUtils.substringBetween(lines[102], "value=\"","\" maxlength="));  //Outdoor Humidity
            wx_e[13] = (StringUtils.substringBetween(lines[107], "value=\"","\" maxlength="));  //Wind Direction 
            wx_e[14] = (StringUtils.substringBetween(lines[112], "value=\"","\" maxlength="));  //Wind Speed
            wx_e[15] = (StringUtils.substringBetween(lines[117], "value=\"","\" maxlength="));  //Wind Gust
            wx_e[16] = (StringUtils.substringBetween(lines[122], "value=\"","\" maxlength="));  //Max Daily Gust
            wx_e[17] = (StringUtils.substringBetween(lines[127], "value=\"","\" maxlength="));  //Solar Raiation
            wx_e[18] = (StringUtils.substringBetween(lines[132], "value=\"","\" maxlength="));  //UV
            wx_e[19] = (StringUtils.substringBetween(lines[137], "value=\"","\" maxlength="));  //UVI
            wx_e[20] = (StringUtils.substringBetween(lines[142], "value=\"","\" maxlength="));  //PM 2.5
            wx_e[21] = (StringUtils.substringBetween(lines[147], "value=\"","\" maxlength="));  //Hourly Rain
            wx_e[22] = (StringUtils.substringBetween(lines[155], "value=\"","\" maxlength="));  //Event Rain
            wx_e[23] = (StringUtils.substringBetween(lines[160], "value=\"","\" maxlength="));  //Daily Rain
            wx_e[24] = (StringUtils.substringBetween(lines[166], "value=\"","\" maxlength="));  //Weekly Rain
            wx_e[25] = (StringUtils.substringBetween(lines[172], "value=\"","\" maxlength="));  //Monthly Rain
            wx_e[26] = (StringUtils.substringBetween(lines[177], "value=\"","\" maxlength="));  //Yearly Temp          

            String outputString = getCurrentTimeStamp("ss") + ",";
            
            for (int i = 0; i < 26; i++) {
               outputString += wx_e[i] + ",";
            }
                output.println(outputString); // Write the coordinate to the file
                
                output.flush();    

       }
       }else{
                output.println(getCurrentTimeStamp("ss") + "Failed to get data");   // If the read did not produce 243 then it was not a good read.  Display an error.
       }
          
  }
  
  
}


/*********************************************************************************
** Load Configuration File Function
*********************************************************************************
*/

void loadConfig() {
       try {
            String config[] = loadStrings("settings.conf");
            String splitC[];
            for (int i = 0; i < config.length; i++) {
          
              splitC = split(config[i], "="); // Load data into array
         
              settings[i] = splitC[1];
            }

           } catch (RuntimeException e) {
                  println(e.getMessage());
             }
            
}
