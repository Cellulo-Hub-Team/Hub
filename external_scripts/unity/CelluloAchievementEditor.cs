using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Runtime.Remoting.Messaging;
using UnityEditor;
using UnityEditor.Experimental.TerrainAPI;
using UnityEditor.UIElements;
using UnityEngine.UIElements;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.SocialPlatforms.Impl;
using UnityEngine.UI;
using Button = UnityEngine.UIElements.Button;

[CustomEditor(typeof(CelluloAchievementDataManager))]
public class CelluloAchievementEditor : Editor
{
    private Box addedAchievementsBox;
    private Button booleanToggle;
    private Button stepsToggle;
    private Button highScoreToggle;
    private IntegerField stepsNumber;
    private CelluloAchievementType type = CelluloAchievementType.Boolean;

    // Override inspector visuals with text fields and buttons
    public override VisualElement CreateInspectorGUI()
    {
        // Root of our UI
        VisualElement inspector = new VisualElement();

        // Button to refresh achievements from file
        Button refreshButton = new Button(RefreshAchievements);
        refreshButton.Add(new Label("Refresh previous achievements"));
        refreshButton.style.backgroundColor = new Color(.35f, .75f, .35f);
        refreshButton.style.fontSize = 15;
        inspector.Add(refreshButton);
        inspector.Add(new Label(" "));


        // Fields to create a new achievement
        Label addTitle = new Label("Create new achievement");
        addTitle.style.fontSize = 20;
        inspector.Add(addTitle);

        Box newAchievement = new Box();
        newAchievement.Add(new Label("\nEnter achievement name"));
        TextField achievementName = new TextField();
        newAchievement.Add(achievementName);


        // Toggles for achievement type
        newAchievement.Add(new Label("\nToggle achievement type (select one)"));
        booleanToggle = new Button(() => UpdateToggles(CelluloAchievementType.Boolean));
        booleanToggle.text = " One-time achievement";
        stepsToggle = new Button(() => UpdateToggles(CelluloAchievementType.Steps));
        stepsToggle.text = " Multiple steps achievement";
        stepsNumber = new IntegerField();
        stepsNumber.label = "               Number of steps ";
        highScoreToggle = new Button(() => UpdateToggles(CelluloAchievementType.HighScore));
        highScoreToggle.text = " High score";
        newAchievement.Add(booleanToggle);
        newAchievement.Add(stepsToggle);
        newAchievement.Add(stepsNumber);
        newAchievement.Add(highScoreToggle);
        inspector.Add(newAchievement);

        // Add new achievement to achievements list
        inspector.Add(new Label(" "));
        Button addButton = new Button(
            () => AddAchievement(
                new CelluloAchievement(achievementName.value, type, stepsNumber.value), false));
        addButton.Add(new Label("Add achievement"));
        addButton.style.backgroundColor = new Color(.35f, .35f, .85f);
        addButton.style.fontSize = 15;
        inspector.Add(addButton);
        inspector.Add(new Label(" "));

        // List of all added achievements
        Label addedTitle = new Label("Achievements added");
        addedTitle.style.fontSize = 20;
        inspector.Add(addedTitle);
        addedAchievementsBox = new Box();
        inspector.Add(addedAchievementsBox);

        // Button to confirm added achievements
        inspector.Add(new Label(" "));
        Button confirmButton = new Button(ConfirmAchievements);
        confirmButton.Add(new Label("Confirm all"));
        confirmButton.style.backgroundColor = new Color(.85f, .35f, .35f);
        confirmButton.style.fontSize = 15;
        inspector.Add(confirmButton);
        inspector.Add(new Label(" "));

        // Return the finished inspector UI
        return inspector;
    }

    // Get previous achievements from file
    private void RefreshAchievements()
    {
        CelluloAchievementDataManager.ReadFile();
        List<CelluloAchievement> temp = CelluloAchievementDataManager.achievementsList;
        for (int i = 0; i < temp.Count; i++)
        {
            Debug.Log(temp.Count);
            AddAchievement(temp[i], true);
        }
    }

    // Add achievement to achievements list and display it in the inspector
    private void AddAchievement(CelluloAchievement achievement, bool isRefreshing)
    {
        if (!isRefreshing)
        {
            foreach (var a in CelluloAchievementDataManager.achievementsList)
            {
                if (a.GetAchievementLabel() == achievement.GetAchievementLabel())
                {
                    return;
                }
            }
            CelluloAchievementDataManager.achievementsList.Add(achievement);
        }
        Box achievementBox = new Box();
        achievementBox.Add(new Label(achievement.GetAchievementLabel()));
        if (achievement.GetAchievementType() == CelluloAchievementType.Steps)
        {
            achievementBox.Add(new Label(
                achievement.GetAchievementTypeString() + " (" + achievement.GetSteps() + " steps)"));
        }
        else
        {
            achievementBox.Add(new Label(achievement.GetAchievementTypeString()));
        }

        // Button to delete achievement from achievements list and remove it from the inspector
        Button removeAchievement = new Button(() =>
        {
            addedAchievementsBox.Remove(achievementBox);
            CelluloAchievementDataManager.achievementsList.Remove(achievement);
        });
        removeAchievement.Add(new Label("Remove"));
        achievementBox.Add(removeAchievement);

        Button delimiter = new Button();
        delimiter.style.height = 3;
        delimiter.SetEnabled(false);
        achievementBox.Add(delimiter);
        addedAchievementsBox.Add(achievementBox);
    }

    // Confirm all added achievements and write them to file
    private void ConfirmAchievements()
    {
        CelluloAchievementDataManager.WriteFile();
    }

    // Select only clicked type and activate number of steps field if needed
    private void UpdateToggles(CelluloAchievementType type)
    {
        Color defaultGrey = new Color(.35f, .35f, .35f);
        Color darkGrey = new Color(.15f, .15f, .15f);
        switch (type)
        {
            case CelluloAchievementType.Boolean:
                booleanToggle.style.backgroundColor = darkGrey;
                stepsToggle.style.backgroundColor = defaultGrey;
                highScoreToggle.style.backgroundColor = defaultGrey;
                stepsNumber.SetEnabled(false);
                this.type = type;
                break;
            case CelluloAchievementType.Steps:
                booleanToggle.style.backgroundColor = defaultGrey;
                stepsToggle.style.backgroundColor = darkGrey;
                highScoreToggle.style.backgroundColor = defaultGrey;
                stepsNumber.SetEnabled(true);
                this.type = type;
                break;
            default:
                booleanToggle.style.backgroundColor = defaultGrey;
                stepsToggle.style.backgroundColor = defaultGrey;
                highScoreToggle.style.backgroundColor = darkGrey;
                stepsNumber.SetEnabled(false);
                this.type = type;
                break;
        }
    }
}
