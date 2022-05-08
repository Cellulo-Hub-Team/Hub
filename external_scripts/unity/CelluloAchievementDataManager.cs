using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.Serialization.Formatters.Binary;
using UnityEngine;

public class CelluloAchievementDataManager : MonoBehaviour
{
    // Create a field for the save file.
    private static string saveFile;
    
    private static int startMinutes;
    private static DateTime startTime;
    
    public static List<CelluloAchievement> achievementsList = new List<CelluloAchievement>();

    private void Awake()
    {
        ReadFile();
    }

    private void Update()
    {
        WriteFile();
    }

    public static void UpdateAchievementValue(String label, int value)
    {
        foreach (var achievement in achievementsList)
        {
            if (achievement.GetAchievementLabel().Equals(label))
            {
                achievement.SetValue(value);
            }
        }
    }
    
    public static void IncreaseAchievementValue(String label)
    {
        foreach (var achievement in achievementsList)
        {
            if (achievement.GetAchievementLabel().Equals(label))
            {
                achievement.IncreaseValue();
            }
        }
    }

    public static void ReadFile()
    {
        saveFile = Application.persistentDataPath + "/achievements.json";
        
        // Does the file exist?
        if (File.Exists(saveFile))
        {
            // Read the entire file and save its contents.
            string[] fileContents = File.ReadAllLines(saveFile);
            int count = Int32.Parse(fileContents[0]);

            for (int i = 1; i < count + 1; i++)
            {
                // Deserialize the JSON data into a pattern matching the achievementData class.
                CelluloAchievementData achievementData = JsonUtility.FromJson<CelluloAchievementData>(fileContents[i]);
                CelluloAchievementType type;
                switch (achievementData.type)
                {
                    case "one": type = CelluloAchievementType.Boolean; break;
                    case "multiple": type = CelluloAchievementType.Steps; break;
                    default: type = CelluloAchievementType.HighScore; break;
                }
                CelluloAchievement achievement =
                    new CelluloAchievement(achievementData.label, type, achievementData.steps);
                achievementsList.Add(achievement);
            }

            startMinutes = Int32.Parse(fileContents[count + 1]);
            startTime = DateTime.Now;
        }
    }

    public static void WriteFile()
    {
        saveFile = Application.persistentDataPath + "/achievements.json";
        File.WriteAllText(saveFile, achievementsList.Count + "\n");
        foreach (var a in achievementsList)
        {
            CelluloAchievementData achievementData = new CelluloAchievementData(
                a.GetAchievementLabel(),
                a.GetAchievementTypeData(),
                a.GetSteps(),
                a.GetValue());
            // Serialize the object into JSON and save string.
            string jsonString = JsonUtility.ToJson(achievementData);

            // Write JSON to file.
            File.AppendAllText(saveFile, jsonString);
            File.AppendAllText(saveFile, "\n");
        }
        //Update total minutes played
        File.AppendAllText(saveFile, Math.Round((DateTime.Now - startTime).TotalMinutes + startMinutes).ToString());
    }
}

class CelluloAchievementData
{
    public string label = "";
    public string type = "";
    public int steps;
    private int value;
    
    public CelluloAchievementData(string label, string type, int steps, int value)
    {
        this.label = label;
        this.type = type;
        this.steps = steps;
        this.value = value;
    }
}
