%module velocityverletplugin

%import(module="openmm.openmm") "swig/OpenMMSwigHeaders.i"
%include "swig/typemaps.i"

/*
 * The following lines are needed to handle std::vector.
 * Similar lines may be needed for vectors of vectors or
 * for other STL types like maps.
 */

%include "std_vector.i"
namespace std {
  %template(vectord) vector<double>;
  %template(vectori) vector<int>;
};

%{
#include "OpenMM.h"
#include "OpenMMAmoeba.h"
#include "OpenMMDrude.h"
#include "openmm/RPMDIntegrator.h"
#include "openmm/RPMDMonteCarloBarostat.h"
#include "openmm/VVIntegrator.h"
%}

%pythoncode %{
import openmm.openmm as mm
import openmm.unit as unit
%}

/*
 * Add units to function outputs.
*/
%pythonappend OpenMM::VVIntegrator::getTemperature() const %{
   val=unit.Quantity(val, unit.kelvin)
%}

%pythonappend OpenMM::VVIntegrator::getFrequency() const %{
   val=unit.Quantity(val, 1 / unit.picosecond)
%}

%pythonappend OpenMM::VVIntegrator::getDrudeTemperature() const %{
   val=unit.Quantity(val, unit.kelvin)
%}

%pythonappend OpenMM::VVIntegrator::getDrudeFrequency() const %{
   val=unit.Quantity(val, 1 / unit.picosecond)
%}

%pythonappend OpenMM::VVIntegrator::getMaxDrudeDistance() const %{
   val=unit.Quantity(val, unit.nanometer)
%}

%pythonappend OpenMM::VVIntegrator::getFriction() const %{
    val=unit.Quantity(val, 1 / unit.picosecond)
%}

%pythonappend OpenMM::VVIntegrator::getDrudeFriction() const %{
    val=unit.Quantity(val, 1 / unit.picosecond)
%}

%pythonappend OpenMM::VVIntegrator::getMirrorLocation() const %{
    val=unit.Quantity(val, unit.nanometer)
%}

%pythonappend OpenMM::VVIntegrator::getElectricField() const %{
    val=unit.Quantity(val, unit.kilojoule / unit.nanometer / unit.elementary_charge).in_units_of(unit.volt / unit.nanometer)
%}

%pythonappend OpenMM::VVIntegrator::getCosAcceleration() const %{
    val=unit.Quantity(val, unit.nanometer / unit.picosecond / unit.picosecond)
%}

%pythonappend OpenMM::VVIntegrator::getViscosity() %{
    val=(unit.Quantity(val[0], unit.nanometer / unit.picosecond),
         unit.Quantity(val[1], unit.picosecond / (unit.dalton * unit.item) * unit.nanometer).in_units_of((unit.pascal * unit.second)**(-1))
        )
%}

namespace OpenMM {

class VVIntegrator : public Integrator {
public:
   VVIntegrator(double temperature, double frequency, double drudeTemperature, double drudeFrequency, double stepSize, int numNHChains=3, int loopsPerStep=1) ;

   double getTemperature() const ;
   void setTemperature(double temp) ;
   double getFrequency() const ;
   void setFrequency(double tau) ;
   double getDrudeTemperature() const ;
   void setDrudeTemperature(double temp) ;
   double getDrudeFrequency() const ;
   void setDrudeFrequency(double tau) ;
   double getMaxDrudeDistance() const ;
   void setMaxDrudeDistance(double distance) ;
   virtual void step(int steps) ;
   int getNumNHChains() const ;
   void setNumNHChains(int numChains) ;
   int getLoopsPerStep() const ;
   void setLoopsPerStep(int loops) ;
   bool getUseCOMTempGroup() const ;
   void setUseCOMTempGroup(bool) ;
   bool getUseMiddleScheme() const ;
   void setUseMiddleScheme(bool) ;

   int addParticleLangevin(int particle) ;
   int getRandomNumberSeed() const ;
   void setRandomNumberSeed(int seed) ;
   int getFriction() const ;
   void setFriction(double fric) ;
   int getDrudeFriction() const ;
   void setDrudeFriction(int fric) ;

   int addImagePair(int, int) ;
   void setMirrorLocation(double) ;
   double getMirrorLocation() const ;
   void addParticleElectrolyte(int) ;
   void setElectricField(double) ;
   double getElectricField() const ;

   void setCosAcceleration(double) ;
   double getCosAcceleration() const ;
   std::vector<double> getViscosity();

   bool getDebugEnabled() const ;
   void setDebugEnabled(bool) ;

};

}
