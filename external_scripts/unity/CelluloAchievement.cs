using System;

public enum CelluloAchievementType
{
    Boolean,
    Steps,
    HighScore
}

// Base class for all Cellulo achievements
public class CelluloAchievement
{
    private string label = "";
    private CelluloAchievementType type = CelluloAchievementType.Boolean;
    private int steps;
    private int value;

    public CelluloAchievement(string label, CelluloAchievementType type, int steps, int value)
    {
        this.label = label;
        this.type = type;
        this.steps = steps;
        this.value = value;
    }

    public string GetAchievementLabel()
    {
        return label;
    }
    
    public CelluloAchievementType GetAchievementType()
    {
        return type;
    }

    public string GetAchievementTypeString()
    {
        switch (type)
        {
            case CelluloAchievementType.Boolean: return "One-time achievement";
            case CelluloAchievementType.Steps: return "Multiple steps";
            default: return "High score";
        }
    }
    
    public string GetAchievementTypeData()
    {
        switch (type)
        {
            case CelluloAchievementType.Boolean: return "one";
            case CelluloAchievementType.Steps: return "multiple";
            default: return "high";
        }
    }
    
    public int GetSteps()
    {
        return steps;
    }
    
    public int GetValue()
    {
        return value;
    }

    public void SetValue(int newValue)
    {
        value = newValue;
    }
    
    public void IncreaseValue()
    {
        value++;
    }
}
