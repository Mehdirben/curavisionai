import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // For handling date formatting

class MedicationReminderPage extends StatefulWidget {
  const MedicationReminderPage({super.key});

  @override
  State<MedicationReminderPage> createState() => _MedicationReminderPageState();
}

class _MedicationReminderPageState extends State<MedicationReminderPage> {
  final List<Map<String, dynamic>> _reminders = []; // Active reminders
  final List<Map<String, dynamic>> _archivedReminders = []; // Archived reminders

  final _medicationController = TextEditingController();
  final _dosageController = TextEditingController();
  final _daysController = TextEditingController();
  final _timesPerDayController = TextEditingController();
  final List<TimeOfDay> _selectedTimes = [];

  String? _medicationError;
  String? _dosageError;
  String? _daysError;
  String? _timesPerDayError;
  String? _selectedTimesError;

  bool _showArchives = false; // Toggle for showing active or archived reminders

  // Function to validate inputs and add a reminder
  void _addReminder(StateSetter setModalState) {
    bool hasError = false;

    // Reset error messages
    setModalState(() {
      _medicationError = null;
      _dosageError = null;
      _daysError = null;
      _timesPerDayError = null;
      _selectedTimesError = null;
    });

    // Validate fields
    if (_medicationController.text.isEmpty) {
      setModalState(() {
        _medicationError = 'Medication name is required';
      });
      hasError = true;
    }

    if (_dosageController.text.isEmpty) {
      setModalState(() {
        _dosageError = 'Dosage is required';
      });
      hasError = true;
    }

    final int? numberOfDays = int.tryParse(_daysController.text);
    if (numberOfDays == null || numberOfDays <= 0) {
      setModalState(() {
        _daysError = 'Enter a valid number of days';
      });
      hasError = true;
    }

    final int? timesPerDay = int.tryParse(_timesPerDayController.text);
    if (timesPerDay == null || timesPerDay <= 0) {
      setModalState(() {
        _timesPerDayError = 'Enter a valid number of times per day';
      });
      hasError = true;
    }

    if (_selectedTimes.length != (timesPerDay ?? 0)) {
      setModalState(() {
        _selectedTimesError =
        'You must select exactly ${timesPerDay ?? 0} times';
      });
      hasError = true;
    }

    // If no errors, add the reminder
    if (!hasError) {
      setState(() {
        _reminders.add({
          'medication': _medicationController.text,
          'dosage': _dosageController.text,
          'days': numberOfDays ?? 0,
          'timesPerDay': timesPerDay ?? 0,
          'times': _selectedTimes
              .map((time) => time.format(context))
              .toList(), // Store times in string format
          'startDate': DateTime.now(), // Start from today
        });
      });

      // Clear the input fields
      _medicationController.clear();
      _dosageController.clear();
      _daysController.clear();
      _timesPerDayController.clear();
      _selectedTimes.clear();

      Navigator.pop(context); // Close the bottom sheet
    }
  }

  // Function to generate sorted reminder events for ALL days
  List<Map<String, dynamic>> _getSortedEvents() {
    List<Map<String, dynamic>> allEvents = [];

    for (var reminder in _reminders) {
      final int days = reminder['days'];
      final List<String> times = List<String>.from(reminder['times']); // Explicit cast to List<String>
      final DateTime startDate = reminder['startDate'];

      // Generate events for each day
      for (int i = 0; i < days; i++) {
        DateTime currentDate = startDate.add(Duration(days: i));

        for (String time in times) {
          allEvents.add({
            'medication': reminder['medication'],
            'dosage': reminder['dosage'],
            'date': currentDate,
            'time': time,
            'parentReminder': reminder, // Reference to parent
          });
        }
      }
    }

    // Sort events by date and time
    allEvents.sort((a, b) {
      DateTime dateA = a['date'];
      DateTime dateB = b['date'];

      if (dateA != dateB) {
        return dateA.compareTo(dateB);
      }

      // Compare times if dates are the same
      TimeOfDay timeA = _parseTime(a['time']);
      TimeOfDay timeB = _parseTime(b['time']);
      return _compareTimes(timeA, timeB);
    });

    return allEvents;
  }

  // Helper function to parse time from "hh:mm AM/PM" format into TimeOfDay
  TimeOfDay _parseTime(String timeString) {
    final timeParts = timeString.split(' ');
    final isPM = timeParts[1] == 'PM';
    final hourAndMinute = timeParts[0].split(':');
    int hour = int.parse(hourAndMinute[0]);
    final int minute = int.parse(hourAndMinute[1]);
    if (isPM && hour != 12) {
      hour += 12;
    } else if (!isPM && hour == 12) {
      hour = 0;
    }
    return TimeOfDay(hour: hour, minute: minute);
  }

  // Helper function to compare two TimeOfDay objects
  int _compareTimes(TimeOfDay timeA, TimeOfDay timeB) {
    if (timeA.hour != timeB.hour) {
      return timeA.hour - timeB.hour;
    }
    return timeA.minute - timeB.minute;
  }

  // Function to mark event as "taken" and move it to the archive
  void _markAsTaken(Map<String, dynamic> event) {
    setState(() {
      final parentReminder = event['parentReminder'];

      // Safely cast `parentReminder['times']` to List<String>
      final List<String> times = List<String>.from(parentReminder['times']);
      times.remove(event['time']);

      if (times.isEmpty) {
        if (parentReminder['days'] <= 1) {
          // Move the parent reminder to archives if no days remain
          _archivedReminders.add(parentReminder);
          _reminders.remove(parentReminder);
        } else {
          // Decrement remaining days and reset times for the next day
          parentReminder['days'] -= 1;
          parentReminder['times'] =
          List<String>.from(event['parentReminder']['times']); // Reset for next day
        }
      } else {
        parentReminder['times'] = times; // Update remaining times
      }
    });
  }

  // Open the Add Reminder Bottom Sheet
  void _showAddReminderSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 16,
                left: 16,
                right: 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Medication Reminder',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[800],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Medication Name Field
                    TextField(
                      controller: _medicationController,
                      decoration: InputDecoration(
                        labelText: 'Medication Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorText: _medicationError,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Dosage Field
                    TextField(
                      controller: _dosageController,
                      decoration: InputDecoration(
                        labelText: 'Dosage (e.g., 1 tablet)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorText: _dosageError,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Days Field
                    TextField(
                      controller: _daysController,
                      decoration: InputDecoration(
                        labelText: 'Number of Days',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorText: _daysError,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // Times Per Day Field
                    TextField(
                      controller: _timesPerDayController,
                      decoration: InputDecoration(
                        labelText: 'Times Per Day',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorText: _timesPerDayError,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setModalState(() {
                          _selectedTimes.clear();
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Time Picker
                    ElevatedButton(
                      onPressed: _selectedTimes.length <
                          (int.tryParse(_timesPerDayController.text) ?? 0)
                          ? () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setModalState(() {
                            _selectedTimes.add(pickedTime);
                          });
                        }
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedTimes.length <
                            (int.tryParse(_timesPerDayController.text) ??
                                0)
                            ? Colors.purple[800]
                            : Colors.grey,
                      ),
                      child: const Text('Add Time'),
                    ),
                    if (_selectedTimesError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _selectedTimesError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),

                    // Display Selected Times
                    Wrap(
                      spacing: 8,
                      children: _selectedTimes
                          .map(
                            (time) => Chip(
                          label: Text(time.format(context)),
                          deleteIcon: const Icon(Icons.close),
                          onDeleted: () {
                            setModalState(() {
                              _selectedTimes.remove(time);
                            });
                          },
                        ),
                      )
                          .toList(),
                    ),
                    const SizedBox(height: 24),

                    // Add Reminder Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _addReminder(setModalState),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[800],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Add Reminder'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sortedEvents = _getSortedEvents();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Back button color (white)
        ),
        title: Text(
          _showArchives ? 'Archived Medications' : 'Medication Reminder',
          style: GoogleFonts.montserrat(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Title color
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple[800],
        actions: [
          IconButton(
            icon: Icon(
              _showArchives ? Icons.list : Icons.archive,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _showArchives = !_showArchives;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _showArchives
                ? _archivedReminders.isEmpty
                ? Center(
              child: Text(
                'No archived medications yet!',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            )
                : ListView.builder(
              itemCount: _archivedReminders.length,
              itemBuilder: (context, index) {
                final reminder = _archivedReminders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      reminder['medication'],
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[800],
                      ),
                    ),
                    subtitle: Text(
                      'Dosage: ${reminder['dosage']}',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                );
              },
            )
                : sortedEvents.isEmpty
                ? Center(
              child: Text(
                'No reminders added yet!',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            )
                : ListView.builder(
              itemCount: sortedEvents.length,
              itemBuilder: (context, index) {
                final event = sortedEvents[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      event['medication'],
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[800],
                      ),
                    ),
                    subtitle: Text(
                      '${event['dosage']} at ${DateFormat('MMM d, yyyy').format(event['date'])} - ${event['time']}',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.check_circle,
                          color: Colors.green),
                      onPressed: () => _markAsTaken(event),
                    ),
                  ),
                );
              },
            ),
          ),

          // Add Reminder Button
          if (!_showArchives)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _showAddReminderSheet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[800],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Add Reminder'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}