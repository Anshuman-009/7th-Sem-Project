# Sentiment Analysis – Runbook

Quick reference for running and troubleshooting the project on Windows.

---

## Prerequisites

- **Windows** (10 or 11 recommended).
- **No prior setup required.** The batch file will try to install Python if it is missing.

---

## How to Run the Project

### 1. Open the project folder

Go to the folder that contains `setup_and_run.bat` and `manage.py` (the `mysite` folder).

**Option A – From File Explorer**

- Navigate to:  
  `...\1-Sentiment Analysis Logistic Regression Code\mysite`
- Click the address bar, type `cmd`, press **Enter**.  
  A Command Prompt will open in this folder.

**Option B – From Command Prompt**

```cmd
cd /d "C:\path\to\1-Sentiment Analysis Logistic Regression Code\mysite"
```

(Replace with your actual path.)

### 2. Start setup and server

Run:

```cmd
setup_and_run.bat
```

- **First run:** The script may install Python, create a virtual environment, install packages, download NLTK data, and train the model. This can take several minutes. When the server is ready, you will see something like:

  ```
  Starting development server at http://127.0.0.1:8000/
  ```

- **Later runs:** If everything was already set up, it will start the server quickly.

### 3. Use the app

1. Open a browser.
2. Go to: **http://127.0.0.1:8000/**
3. Type a sentence in the box and click **ANALYZE** to see the sentiment (Positive / Negative / Neutral).

### 4. Stop the server

In the Command Prompt window where the server is running, press **Ctrl+C**.  
To start again, run `setup_and_run.bat` again from the same folder.

---

## If the Server Stops (Crash or Closed Window)

1. Open Command Prompt in the **mysite** folder (same as step 1 above).
2. Run:

   ```cmd
   setup_and_run.bat
   ```

   Setup steps will be skipped if already done; the server will start again. You can run this anytime the app is down.

---

## What the Batch File Does

| Step | Action |
|------|--------|
| 1 | Checks for Python; if missing, tries to install it (e.g. via winget). |
| 2 | Creates a virtual environment (`venv`) if it does not exist. |
| 3 | Activates the venv and installs packages from `requirements.txt`. |
| 4 | Downloads NLTK data (twitter_samples, stopwords). |
| 5 | If model files are missing, trains the sentiment model once (writes `polls\freqs.pickle` and `polls\theta.pickle`). |
| 6 | Runs Django migrations and starts the development server. If the server exits, it restarts automatically after a few seconds. |

---

## Troubleshooting

### “Python not found” and winget did not install it

- Install Python manually: https://www.python.org/downloads/
- During installation, **check “Add Python to PATH”**.
- Restart the Command Prompt, go back to the **mysite** folder, and run `setup_and_run.bat` again.

### “pip install” or “Django” errors

- Ensure you are in the folder that contains `setup_and_run.bat` and `manage.py`.
- Delete the `venv` folder in that directory, then run `setup_and_run.bat` again so it recreates the venv and reinstalls packages.

### NLTK or “twitter_samples” / “stopwords” errors

- The batch file downloads this data automatically. If it still fails, open Command Prompt in the **mysite** folder, activate the venv, and run:

  ```cmd
  venv\Scripts\activate
  python -c "import nltk; nltk.download('twitter_samples'); nltk.download('stopwords')"
  ```

  Then run `setup_and_run.bat` again.

### “This site can’t be reached” or connection errors

- Confirm the server is running (Command Prompt shows “Starting development server at http://127.0.0.1:8000/”).
- Use exactly: **http://127.0.0.1:8000/** (not https, not a different port).
- Try in another browser or in a private/incognito window.

### Port 8000 already in use

- Another program may be using port 8000. Close other Command Prompt windows that might be running the same project, or restart the PC, then run `setup_and_run.bat` again.
- Alternatively, run the server on another port (e.g. 8001):

  ```cmd
  venv\Scripts\activate
  python manage.py runserver 8001
  ```

  Then open **http://127.0.0.1:8001/** in the browser.

### Moving or copying the project to another PC

- Copy the whole **mysite** folder (including `venv` if you want to avoid reinstalling packages).
- On the new PC, open Command Prompt in that **mysite** folder and run `setup_and_run.bat`.  
  If you did not copy `venv`, the batch file will create it and install everything again.

---

## Folder layout (reference)

```
mysite/
├── setup_and_run.bat    ← Run this to set up and start the app
├── RUNBOOK.md           ← This file
├── requirements.txt
├── manage.py
├── mysite/              (Django project settings)
├── polls/               (Sentiment app and model files)
│   ├── freqs.pickle     (created on first run)
│   ├── theta.pickle     (created on first run)
│   └── ...
└── venv/                (created by setup_and_run.bat)
```

---

## Quick commands (after venv exists)

From the **mysite** folder:

| Task | Command |
|------|--------|
| Start/restart app | `setup_and_run.bat` |
| Start server only (no setup) | `venv\Scripts\activate` then `python manage.py runserver` |
| Stop server | **Ctrl+C** in the server window |

---

*For questions or issues, refer to this runbook or the project documentation.*
