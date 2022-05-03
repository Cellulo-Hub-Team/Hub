using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using UnityEngine;

public class CelluloAchievementDataManager : MonoBehaviour
{
    // Create a field for the save file.
    private static string saveFile;
    public static List<CelluloAchievement> ReadFile()
    {
        saveFile = Application.persistentDataPath + "/achievements.json";
        List<CelluloAchievement> achievementsList = new List<CelluloAchievement>();
        
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
                CelluloAchievementType type = CelluloAchievementType.Boolean;
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
        }

        return achievementsList;
    }

    public static void WriteFile(List<CelluloAchievement> achievements)
    {
        saveFile = Application.persistentDataPath + "/achievements.json";
        File.WriteAllText(saveFile, achievements.Count.ToString() + "\n");
        foreach (var a in achievements)
        {
            CelluloAchievementData achievementData = new CelluloAchievementData(
                a.GetAchievementLabel(),
                a.GetAchievementTypeData(),
                a.GetSteps());
            // Serialize the object into JSON and save string.
            string jsonString = JsonUtility.ToJson(achievementData);

            // Write JSON to file.
            File.AppendAllText(saveFile, jsonString);
            File.AppendAllText(saveFile, "\n");
        }
    }
}

class CelluloAchievementData
{
    public string label = "";
    public string type = "";
    public int steps = 0;
    
    public CelluloAchievementData(string label, string type, int steps)
    {
        this.label = label;
        this.type = type;
        this.steps = steps;
    }
}
