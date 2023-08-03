# Unresolved Error

**Yuxuan Fang**

---

08/03/2023 00:17

In `main.m`, at line 210, some internal errors occured thus raised a warning **(Error during serialization)**.

```
Warning: Error occurred while executing the listener callback for event DBStop defined for class matlab.internal.editor.debug.DebugManager:
Error during serialization

Error in matlab.internal.editor.figure.SerializedFigureState/serialize

Error in matlab.internal.editor.FigureProxy/createWebFigureSnapshot

Error in matlab.internal.editor.FigureManager

Error in matlab.internal.editor.FigureManager

Error in matlab.internal.editor.FigureManager.saveSnapshot

Error in matlab.internal.editor.FigureManager.snapshotPendingFigures

Error in GenerateSensorLocations (line 27)
        xySensorLocations(idx, :) = xy_all_possible(select_idx, 1:2);

Error in LiveEditorEvaluationHelperE1201796121 (line 222)
        GenerateSensorLocations(mapPointsNormal.S_building_sens, num_receivers);
```

Then at line 221, the warning persisted.

```
Warning: Error occurred while executing the listener callback for event POST_REGION defined for class matlab.internal.language.RegionEvaluator:
Error using getByteStreamFromArray
Error during serialization

Error in matlab.internal.editor.figure.SerializedFigureState/serialize

Error in matlab.internal.editor.FigureProxy/createWebFigureSnapshot

Error in matlab.internal.editor.FigureManager

Error in matlab.internal.editor.FigureManager

Error in matlab.internal.editor.FigureManager.saveSnapshot

Error in matlab.internal.editor.FigureManager.snapshotAllFigures
```

Also, there's an error:

```
Index in position 1 exceeds array bounds.

Error in GenerateSensorLocations (line 27)
        xySensorLocations(idx, :) = xy_all_possible(select_idx, 1:2);
```

However, if you check the function `GenerateSensorLocations()`, theoretically there's NO bound exceeding.

---