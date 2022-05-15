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
    private static string filePath;

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

    // Changes value of achievement
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

    // Increase value of achievement by 1
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

    // Set achievement to completed
    public static void SetAchievementTrue(String label)
    {
        IncreaseAchievementValue(label);
    }

    // Read achievements file and completes achievements list with its content
    public static void ReadFile()
    {
        filePath = Application.persistentDataPath + "/achievements.json";

        // Read developer file if game is played for the first time
        if (!File.Exists(filePath))
        {
            filePath = Application.dataPath + "/achievements.json";
        }

        // Read the entire file and save its contents.
        string[] fileContents = File.ReadAllLines(filePath);
        int count = Int32.Parse(fileContents[0]);

        for (int i = 1; i < count + 1; i++)
        {
            // Deserialize the JSON data into a pattern matching the achievementData class.
            CelluloAchievementData achievementData = JsonUtility.FromJson<CelluloAchievementData>(fileContents[i]);
            CelluloAchievementType type;
            print(achievementData.type);
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

    // Writes achievements list to file
    public static void WriteFile()
    {
        filePath = Application.persistentDataPath + "/achievements.json";

        File.WriteAllText(filePath, achievementsList.Count + "\n");
        foreach (var a in achievementsList)
        {
            CelluloAchievementData achievementData = new CelluloAchievementData(
                a.GetAchievementLabel(),
                a.GetAchievementTypeData(),
                a.GetSteps(),
                a.GetValue());
            // Serialize the object into JSON and save string
            string jsonString = JsonUtility.ToJson(achievementData);

            // Write JSON string to file
            File.AppendAllText(filePath, jsonString);
            File.AppendAllText(filePath, "\n");
        }
        // Update total minutes played
        File.AppendAllText(filePath, Math.Round((DateTime.Now - startTime).TotalMinutes + startMinutes).ToString());
    }
}

// Formatted achievement class for JSON conversion
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
