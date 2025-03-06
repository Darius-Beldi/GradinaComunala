# Community Garden Management System

A comprehensive Oracle database system for managing urban community gardens. This system enables efficient administration of garden plots, community members, plants, maintenance tasks, and shared tools.

## Project Overview

The Community Garden Management System allows garden associations to:
- Track plot allocation and manage member information
- Monitor plant varieties and harvests
- Schedule and assign maintenance tasks
- Manage shared tools and equipment
- Generate reports and insights about garden activities

## Database Schema

The system is built around the following key entities:

### Main Entities
- **MEMBRII** - Community garden participants
- **PARCELE** - Individual garden plots
- **PLANTE** - Varieties that can be grown
- **SARCINI_INTRETINERE** - Regular garden upkeep activities
- **UNELTE** - Shared equipment for garden maintenance

### Relationship Entities
- **ATRIBUIRI_PARCELE** - Assigns plots to members for specific time periods
- **PLANTE_PARCELE** - Records which plants are growing in which plots
- **PROGRAMARI_SARCINI** - Manages maintenance task assignments
- **UNELTE_SARCINI** - Tracks which tools are needed for specific tasks
- **RECOLTE** - Records yield information from plots

![image](https://github.com/user-attachments/assets/c2e14a59-a351-40e1-a6af-4400343c861d)


## Features

- **Member Management**: Track contact information (nume, prenume, email, telefon), registration dates (data_inscriere), and active status (activ)
- **Plot Administration**: Manage plot locations (locatie), sizes (suprafata_mp), water access (acces_apa), and monthly fees (taxa_lunara)
- **Plant Catalog**: Store information about plant varieties (nume, specie), growing instructions (instructiuni_ingrijire), and seasons (sezon)
- **Harvest Tracking**: Record harvest dates (data_recoltare), quantities (cantitate_kg), and quality ratings (evaluare_calitate)
- **Maintenance Planning**: Schedule tasks, assign members (membru_asignat_id), and track task status (stare)
- **Tool Inventory**: Manage shared tools including maintenance dates (ultima_intretinere) and availability (disponibila)
- **Data Analysis**: Various stored procedures and triggers to analyze garden performance

## Technical Implementation

The system is implemented in Oracle Database (21c) and includes:

- Table definitions with appropriate constraints (primary keys, foreign keys, CHECK constraints)
- Stored procedures for common operations (procedures and functions)
- Custom collection types for data handling (TABLE, VARRAY, and INDEX BY collections)
- Parameterized and dependent cursors for complex queries
- Exception handling (both predefined exceptions like NO_DATA_FOUND and custom exceptions)
- Database triggers (LMD at command level, LMD at row level, and LDD triggers)

## Sample Procedures

The system includes several advanced stored procedures:

1. **gestionare_date**: Procedure that uses three types of collections to analyze plot usage, plants and maintenance costs
2. **membrii_plante**: Uses dependent cursors to display plants cultivated by each member
3. **nrRecolteExcelente**: Function that calculates the number of excellent-rated harvests
4. **verificare_membru_plante**: Checks if members have specific plants growing in particular locations and seasons

## Installation and Setup

1. Create a new Oracle database schema
2. Run the table creation scripts in the following order:
   - Base tables (Members, Parcels, Plants, Tools, Tasks)
   - Relationship tables (Plot allocations, plant assignments, etc.)
3. Run the sequence creation scripts
4. Populate the tables with sample data
5. Create stored procedures, functions, and triggers

## Usage Examples

```sql
-- Assign a plot to a member
INSERT INTO ATRIBUIRI_PARCELE VALUES (seq_atribuiri.NEXTVAL, 1, 1, TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'));

-- Record a harvest
INSERT INTO RECOLTE VALUES (seq_recolte.NEXTVAL, 1, 1, TO_DATE('2024-09-01', 'YYYY-MM-DD'), 25.5, 'Excelenta');

-- Schedule a maintenance task
INSERT INTO PROGRAMARI_SARCINI VALUES (seq_programari.NEXTVAL, 1, 1, 1, TO_DATE('2024-02-01', 'YYYY-MM-DD'), 'Programata');

-- Check member's plants by location and season
EXEC verificare_membru_plante(1, 'Zona A1', 'Vara');

-- Get count of excellent harvests for a member
SELECT nrRecolteExcelente(1) FROM DUAL;

-- Display garden data analysis for a specific parcel
EXEC gestionare_date(2);

-- List all plants grown by each member
EXEC membrii_plante();
```
