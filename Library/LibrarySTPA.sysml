library package LibrarySTPA {
    
    private import ScalarValues::*;
    private import Views::*;
    
    doc /*  
        This library contains the System-Theoretic Process Analysis (STPA) language extension for SysML v2. 
        The package is structured according to the four steps of the STPA:
        1. Defining the purpose of the analysis
        2. Modelling the control structure
        3. Identifying unsafe control control actions
        4. Identifying loss scenarios
        In addition, two package are included that help to improve usability of the library:
        5. Defines MetaData for relevant STPA types
        6. Defines Views and Viewpoints for STPA activities
    */

    package DefineAnalysisPurpose {
        doc /*  
            This package contains the elements related to the first step of the STPA. 
            The first step covers the definition of losses and hazards
            as the baseline for the analysis.
        */

        abstract part def Loss {
            doc /* 
                Definition:
                Represent the act or fact of being unable to keep or
                maintain something valued by a stakeholder.
                Losses may include harm to people, property losses,
                environmental losses, mission losses, 
                loss of system performance, reputation losses, or 
                any other relevant losses determined by the stakeholders. 
                
                Model-Based Composition:
                Loss = <StateOfConcern> & <StakeholderConcern>
                
                Example:
                <Loss of> <life>.
            */
            abstract attribute stateOfConcern : StatesOfConcern;
            abstract concern stakeholderConcern;
        }
        abstract part losses[*] : Loss;
        
        enum def StatesOfConcern {
            'Loss of';
            'Occurrence of';
        }
        
        abstract part def Hazard {
            doc /* 
                Definition:
                Represents a system state or set of conditions that together with a 
                particular set of worst-case environmental conditions, will lead to a loss.
                
                Model-Based Composition:
                Hazard = <System> & <UnsafeCondition> & [Losses]
                
                Example:
                <Automated vehicle> <loses control> resulting in [loss of life].
             */
            abstract ref part system[1];
            abstract attribute unsafeCondition[1] : String;
            abstract ref part linkedLosses[1..*] : Loss;
        }
        abstract part hazards[*] : Hazard;
    }
    package ModelControlStructure {
        doc /* 
            This package contains the elements related to the second step of the STPA. 
            The second step covers the modelling of the control structure.
        */

        abstract part def ControlStructure {
            doc /* 
                Definition:
                Represents a hierarchical structure that models the layers of control in a system. 
                Each level imposes constraints on the activities of the levels below, and each level may receive feedback or other information about the levels below. 
                Control structures model the relationships and interactions between controllers, controlled processes, control actions, feedback, and other information.
                
                Example:
                A control oriented model showing the interactions of an automated vehicle with related systems and people.
            */
            abstract ref part actuatorsCS[*] : Actuator;
            abstract ref part sensorsCS[*] : Sensor;
            abstract ref part processesCS[*] : Process;
            abstract ref part controllersCS[*] : Controller;
            abstract ref item controlActionsCS[*] : ControlAction;
            abstract ref item feedbacksCS[*] : Feedback;
            abstract ref item otherInformationsCS[*] : OtherInformation;
        }
        abstract part controlStructures[*] : ControlStructure;
        
        abstract part def Controller {
            doc /* 
                Definition:
                Represents an entity that forms beliefs, makes decisions, and provides control actions to achieve or maintain a state or goal.

                Example:
                ControlElectronics of an automated vehicle.
            */
            abstract part processBeliefs[*] : ProcessModel;
        }
        abstract part controllers[*] : Controller;
        
        abstract part def HumanController :> Controller {
            doc /* 
                Definition:
                Represents a human that takes over controller related activities.
                
                Example:
                Teleoperator which makes decisions about the operation of an automated vehicle.
            */
            abstract part mentalBeliefs[*] : MentalModel;
        }
        abstract part humanControllers[*] : HumanController;
        
        abstract part def ProcessModel {
            doc /*
                Definition:
                A representation of a controller's internal beliefs used to make decisions. 
                Process models may include beliefs about the controlled process or other relevant aspects of the system or the environment. 
                Process models may be partly updated by feedback used to observe the controlled process.
                
                Example:
                Navigation map used by the ControlElectronics of the automated vehicle. 
            */
            
        }
        abstract part processModels[*] : ProcessModel;
        
        abstract part def MentalModel :> ProcessModel {
            doc /*
                Definition:
                A representation of someone's thought process about how something works in the real world. 
                It describes the surrounding world, the relationships between its various parts, and a person's intuitive perception about their own acts and consequences.
                
                Example:
                Teleoperator's idea of which vehicle he supervises.
            */
        }
        abstract part mentalModels[*] : MentalModel;
        
        abstract part def Actuator {
            doc /* 
                Definition:
                Represents an entity in the control structure which executes a control action by a controller.

                Example:
                Brake of the automated vehicle.
            */
        }
        abstract part actuators[*] : Actuator;
        
        abstract part def Sensor {
            doc /* 
            Definition:
            Represents an entitiy in the control structure which provides feedback to a controller.
            
            Example:
            Perception system of automated vehicle.
            */
        }
        abstract part sensors[*] : Sensor;
        
        abstract part def Process {
            doc /* 
                Definition:
                Represents any process, such as a physical process, a virtual process, a controller, or other processes 
                that receives control actions from and provides feedback to higher-level controllers in a control structure.  
                Processes with specified restrictions that bound the performance of its intended behavior.
                
                Example:
                Movement of the automated vehicle.
            */
        }
        abstract part processes[*] : Process;

        abstract item def ControlAction {
            doc /* 
                Definition:
                Represents a command, instruction, or other directive 
                provided by a controller to control a process and achieve goals.

                Example:
                Teleopartor command.
            */
        }
        abstract item controlActions[*] : ControlAction;
        
        abstract item def Feedback {
            doc /* 
            Definition:
            Represents a value, measurement or other information provided to a controller to achieve its goals.
            
            Example:
            Camera images.
            */
        }
        abstract item feedbacks[*] : Feedback;
        
        abstract item def OtherInformation {
            doc /*
            Definition:
            Represents values that may come from other processes, other controllers, or other sources in the system or the environment.
            
            Example:
            Sunlight from the environment.
            */
        }
        abstract item otherInformation[*] : OtherInformation;
    }

    package IdentifyUCAs {
        doc /* 
            This package contains the elements related to the third step of the STPA. 
            The third step covers the identification of unsafe control actions.
        */
            
        abstract part def Context {
            doc /* 
                Definition:
                Conditions where a control action may be unsafe.
                Context can be a state of the system or the state of the operational environment.

                Example:
                Environmental Context = A road closure within a one way street.
                System Context = An automated vehicle is in an emergency state.
            */
            abstract ref part environmentalCondition : EnvironmentalCondition;
            abstract ref part systemCondition : SystemCondition;
        }
        abstract part contexts[*] : Context;
        abstract part def EnvironmentalCondition;
        abstract part environmentalConditions[*] : EnvironmentalCondition;
        abstract part def SystemCondition;
        abstract part systemConditions[*] : SystemCondition;
            
        enum def TypesOfCA {
            doc /* 
                Definition:
                Represents different types of how a control action can be unsafe.

                Example:
                Teleoperator command is NotProvided.
            */
            NotProvided;
            Provided;
            ProvidedIncorrectly;
            ProvidedTooLate;
            ProvidedTooSoon;
            ProvidedOutOfOrder;
        }
        enum typesOfCAs[*] : TypesOfCA;
    
        abstract item def UnsafeControlAction :> ModelControlStructure::ControlAction {
            doc /* 
                Definition:
                Represents a control action that, in a particular context, will lead to a hazard, 
                and may eventually, given worst-case environmental conditions, lead to losses.

                Model-Based Composition:
                UCA = <Source> & <Type> & <ControlAction> & <Receiver> & <Context> & [Hazards]

                Example:
                UCA = The <teleoperator> <does not provide> the <operation command> to the <automated vehicle> 
                <during a complex traffic situation> leading to [H1 - the vehicle not being able to continue its mission].
            */
            abstract ref source[1];
            abstract enum type[1] : TypesOfCA;
            abstract ref item controlAction[1] : ModelControlStructure::ControlAction;
            abstract ref receiver[1];
            abstract ref part context[1] : Context;
            abstract ref part linkedHazards[1..*] : DefineAnalysisPurpose::Hazard;
        }
        abstract item unsafeControlActions[*] : UnsafeControlAction;
        
        abstract item def UnwantedControlAction :> UnsafeControlAction;
        abstract item unwantedControlActions[*] : UnwantedControlAction;
        abstract item def UnsecureControlAction :> UnsafeControlAction;
        abstract item unsecureControlAction[*] : UnsecureControlAction;
    }

    package IdentifyLSs {
        doc /* 
            This package contains the elements related to the fourth step of the STPA. 
            The fourth step covers the identification of loss scenarios. 
        */
        
        abstract part def CausalFactor {
            doc /*
                Definition:
                Represents a circumstance, fact, or influence contributing to a causal scenario. 
                Causal factors can include: interactions, process models, contextual variables, etc.

                Example:
                Interaction = <Teleoperator command> & <not forwarded>.
                Process model = <Awareness of supervised vehicles> & <is incorrect>.
                
            */
            abstract ref item factor[1];
            abstract attribute status : String;
        }
        abstract part causalFactors[*] : CausalFactor;
        
        abstract part def LossScenario {
            doc /*
                Definition:
                Represents the causal factors that can lead to unsafe control actions and to hazards.
                
                Model-Based Composition:
                LS = <CausalFactors> & [UCAs]

                Example:
                <Teleoperator command> & <not forwarded> leading to [UCA1]
                <Awareness of supervised vehicles> & <is incorrect> leading to [UCA2]  
            */
            abstract ref part scenarioFactors[1..*] : IdentifyLSs::CausalFactor;
            abstract ref item ucas[1..*] : IdentifyUCAs::UnsafeControlAction;
        }
        abstract part lossScenarios[*] : LossScenario;
    }
    
    package MetaTypesSTPA {
        doc /* 
            This package contains all the meta types for the STPA library elements
        */

        ////////// Define Analysis Purpose Meta Types //////////
        metadata def <loss> :> Metaobjects::SemanticMetadata {
        :>> baseType = DefineAnalysisPurpose::losses meta SysML::PartUsage;
        }
        metadata def <hazard> :> Metaobjects::SemanticMetadata {
            :>> baseType = DefineAnalysisPurpose::hazards meta SysML::PartUsage;
        }

        ////////// Model Control Structure Meta Types  //////////
        metadata def <controlStructure> :> Metaobjects::SemanticMetadata {
            :>> baseType = ModelControlStructure::controlStructures meta SysML::PartUsage;
        }
        
        metadata def <controller> :> Metaobjects::SemanticMetadata {
          :>> baseType = ModelControlStructure::controllers meta SysML::PartUsage;
        }
        
        metadata def <controllerHuman> :> Metaobjects::SemanticMetadata {
          :>> baseType = ModelControlStructure::humanControllers meta SysML::PartUsage;
        }

        metadata def <actuator> :> Metaobjects::SemanticMetadata {
          :>> baseType = ModelControlStructure::actuators meta SysML::PartUsage;
        }

        metadata def <sensor> :> Metaobjects::SemanticMetadata {
          :>> baseType = ModelControlStructure::sensors meta SysML::PartUsage;
        }

        metadata def <process> :> Metaobjects::SemanticMetadata {
          :>> baseType = ModelControlStructure::processes meta SysML::PartUsage;
        }
        
        metadata def <controlAction> :> Metaobjects::SemanticMetadata {
          :>> baseType = ModelControlStructure::controlActions meta SysML::ItemUsage;
        }
        
        metadata def <feedback> :> Metaobjects::SemanticMetadata {
          :>> baseType = ModelControlStructure::feedbacks meta SysML::ItemUsage;
        }
        
        metadata def <processModel> :> Metaobjects::SemanticMetadata {
          :>> baseType = ModelControlStructure::processModels meta SysML::PartUsage;
        }
        
        metadata def <mentalModel> :> Metaobjects::SemanticMetadata {
          :>> baseType = ModelControlStructure::mentalModels meta SysML::PartUsage;
        }
        
        ////////// Identify UCA Meta Types //////////
        metadata def <uca> :> Metaobjects::SemanticMetadata {
            :>> baseType = IdentifyUCAs::unsafeControlActions meta SysML::ItemUsage;
        }
        
        metadata def <envCon> :> Metaobjects::SemanticMetadata {
            :>> baseType = IdentifyUCAs::environmentalConditions meta SysML::PartUsage;
        }
        
        metadata def <sysCon> :> Metaobjects::SemanticMetadata {
            :>> baseType = IdentifyUCAs::systemConditions meta SysML::PartUsage;
        }
        
        metadata def <context> :> Metaobjects::SemanticMetadata {
            :>> baseType = IdentifyUCAs::contexts meta SysML::PartUsage;
        }
        
        ////////// Identify LSs Meta Types //////////
        metadata def <cf> :> Metaobjects::SemanticMetadata {
            :>> baseType = IdentifyLSs::causalFactors meta SysML::PartUsage;
        }
        
        metadata def <ls> :> Metaobjects::SemanticMetadata {
            :>> baseType = IdentifyLSs::lossScenarios meta SysML::PartUsage;
        }
    }
    
    package ViewsAndViewpoints {
        private import MetaTypesSTPA::*;
        
        doc /* 
            This package contains all the views and viewpoints for the utilization of the STPA library elements
        */    
        
        package DefineAnalysisPurposeViews {            
            viewpoint DefineLosses {
                doc /* It should be possible to define and show all losses of the system of interest */
                view def LossTree {
                    doc /* A tree diagram is one possibility to create and manage losses */
                    satisfy DefineLosses;
                    render asTreeDiagram;
                    filter @loss;
                }
            }
            viewpoint DefineHazards {
                doc /* It should be possible to define and show all hazards of the system of interest */
                view def HazardTree {
                    doc /* A tree diagram is one possibility to create and manage hazards */
                    satisfy DefineHazards;
                    render asTreeDiagram;
                    filter @hazard;
                }
            }
            viewpoint MapLossesToHazards {
                doc /* It should be possible to map every loss to at least one hazard */
                view def LossesToHazardsMatrix {
                    doc /* A relationship matrix is one possibility to create and manage relationships 
                        between losses and hazards */
                    satisfy MapLossesToHazards;
                    filter @hazard or @loss;
                    //render asRelationshipMatrix;
                }
            }
        }
        package ModelControlStructureViews {
            viewpoint ModelControlStructure {
                doc /* It should be possible to model the control structure with elements 
                and interactions of the system of interest */
                view def ControlStructureInterconnection {
                    doc /* An interconnection diagram is one possibility to create and manage a control structure */
                    satisfy ModelControlStructure;
                    render asInterconnectionDiagram;
                    filter @controlStructure or @controller or @controllerHuman or @actuator or @process 
                        or @sensor or @controlAction or @feedback or @mentalModel or @processModel;
                }
            }
        }
        
        package IdentifyUCAsViews {
            viewpoint DefineContext {
                doc /* It should be possible to define the context of the system of interest */
                view def ContextTable {
                    doc /* An element table is one possibility to create and manage the context */
                    satisfy DefineContext;
                    render asElementTable;
                    filter @context;
                }
            }
            viewpoint IdentifyUCAs {
                doc /* It should be possible to identify UCAs for the system of interest */
                view def UCAsTable {
                    doc /* An element table is one possibility to create and manage UCAs */
                    satisfy IdentifyUCAs;
                    render asElementTable;
                    filter @uca;
                }
            }
        }
        package IdentifyLSsViews {
            viewpoint IdentifyLSs {
                doc /* It should be possible to identify LSs for the system of interest */
                view def LSsTable {
                    doc /* An element table is one possibility to create and manage LSs */
                    satisfy IdentifyLSs;
                    render asElementTable;
                    filter @ls;
                }
            }
            viewpoint MapUCAsToLSs {
                doc /* It should be possible to map at least one UCA to each loss scenario */
                view def LSsToUCAsMatrix {
                    doc /* A relationship matrix is one possibility to create and manage relationships between LSs and UCAs */
                    satisfy MapUCAsToLSs;
                    //render asRelationshipMatrix;
                    filter @ls or @uca;
                }
            }
        }
    }
}